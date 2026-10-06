require "test_helper"

class CompensationGeneratorTest < ActiveSupport::TestCase
  setup do
    @country = Country.create!(name: "India", iso_code: "IN")
    @department = Department.create!(name: "Engineering")
    @job_level = JobLevel.create!(name: "Senior")
    @currency = Currency.create!(
      code: "USD",
      name: "US Dollar",
      symbol: "$"
    )
  end

  test "generates current compensation for a newly joined employee" do
    employee = create_employee(
      employee_number: "EMP-2001",
      email: "employee2001@example.com",
      joining_date: Date.current
    )

    CompensationGenerator.generate

    records = employee.compensation_records.order(:effective_from)

    assert_equal 1, records.count
    assert_equal Date.current, records.first.effective_from
    assert_nil records.first.effective_to
  end

  test "generates compensation history for an existing employee" do
    employee = create_employee(
      employee_number: "EMP-2002",
      email: "employee2002@example.com",
      joining_date: Date.new(2024, 1, 1)
    )

    CompensationGenerator.generate

    records = employee.compensation_records.order(:effective_from)

    assert_operator records.count, :>, 1
    assert_equal Date.new(2024, 1, 1), records.first.effective_from
    assert_nil records.last.effective_to
  end

  test "creates continuous non-overlapping compensation periods" do
    employee = create_employee(
      employee_number: "EMP-2003",
      email: "employee2003@example.com",
      joining_date: Date.new(2024, 1, 1)
    )

    CompensationGenerator.generate

    records = employee.compensation_records.order(:effective_from)

    records.each_cons(2) do |current, following|
      assert_equal current.effective_to, following.effective_from
    end
  end

  test "increases salary for each compensation period" do
    employee = create_employee(
      employee_number: "EMP-2004",
      email: "employee2004@example.com",
      joining_date: Date.new(2024, 1, 1)
    )

    CompensationGenerator.generate

    salaries = employee.compensation_records
      .order(:effective_from)
      .pluck(:annual_base_salary)

    salaries.each_cons(2) do |previous, current|
      assert_operator current, :>, previous
    end
  end

  test "does not create future compensation periods" do
    employee = create_employee(
      employee_number: "EMP-2005",
      email: "employee2005@example.com",
      joining_date: Date.current + 1.day
    )

    CompensationGenerator.generate

    assert_equal 0, employee.compensation_records.count
  end

  test "does not generate duplicate compensation for an employee" do
    employee = create_employee(
        employee_number: "EMP-2006",
        email: "employee2006@example.com",
        joining_date: Date.new(2024, 1, 1)
    )

    CompensationGenerator.generate
    first_count = employee.compensation_records.count

    CompensationGenerator.generate
    assert_equal first_count, employee.compensation_records.count
  end

  private

  def create_employee(employee_number:, email:, joining_date:)
    Employee.create!(
      employee_number: employee_number,
      first_name: "Test",
      last_name: "Employee",
      email: email,
      country: @country,
      department: @department,
      job_level: @job_level,
      job_title: "Senior Software Engineer",
      employment_status: "active",
      joining_date: joining_date
    )
  end
end
