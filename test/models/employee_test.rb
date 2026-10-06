require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  setup do
    @country = Country.create!(name: "India", iso_code: "IN")
    @department = Department.create!(name: "Engineering")
    @job_level = JobLevel.create!(name: "Senior")

    @employee_attributes = {
      employee_number: "EMP-1001",
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      country: @country,
      department: @department,
      job_level: @job_level,
      job_title: "Senior Software Engineer",
      employment_status: "active",
      joining_date: Date.new(2024, 1, 15)
    }

    @employee = Employee.create!(@employee_attributes)
  end

  test "is valid with all required attributes" do
    employee = Employee.new(
      @employee_attributes.merge(
        employee_number: "EMP-1002",
        email: "valid@example.com"
      )
    )

    assert employee.valid?
  end

  test "requires an employee number" do
    employee = Employee.new(@employee_attributes.except(:employee_number))

    assert_not employee.valid?
    assert_includes employee.errors[:employee_number], "can't be blank"
  end

  test "requires a unique employee number" do
    duplicate = Employee.new(@employee_attributes.merge(email: "another@example.com"))

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:employee_number], "has already been taken"
  end

  test "requires an email" do
    employee = Employee.new(@employee_attributes.except(:email))

    assert_not employee.valid?
    assert_includes employee.errors[:email], "can't be blank"
  end

  test "requires a unique email" do
    duplicate = Employee.new(
      @employee_attributes.merge(employee_number: "EMP-1002")
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "requires a valid employment status" do
    employee = Employee.new(
      @employee_attributes.merge(employment_status: "on_leave")
    )

    assert_not employee.valid?
    assert employee.errors[:employment_status].any?
  end

  test "accepts active employment status" do
    employee = Employee.new(
      @employee_attributes.merge(
        employee_number: "EMP-1002",
        email: "active@example.com",
        employment_status: "active"
      )
    )

    assert employee.valid?
  end

  test "accepts inactive employment status" do
    employee = Employee.new(
      @employee_attributes.merge(
        employee_number: "EMP-1003",
        email: "inactive@example.com",
        employment_status: "inactive"
      )
    )

    assert employee.valid?
  end

  test "accepts terminated employment status" do
    employee = Employee.new(
      @employee_attributes.merge(
        employee_number: "EMP-1004",
        email: "terminated@example.com",
        employment_status: "terminated"
      )
    )

    assert employee.valid?
  end

  test "requires a country" do
    employee = Employee.new(@employee_attributes.except(:country))

    assert_not employee.valid?
    assert_includes employee.errors[:country], "must exist"
  end

  test "requires a department" do
    employee = Employee.new(@employee_attributes.except(:department))

    assert_not employee.valid?
    assert_includes employee.errors[:department], "must exist"
  end

  test "requires a job level" do
    employee = Employee.new(@employee_attributes.except(:job_level))

    assert_not employee.valid?
    assert_includes employee.errors[:job_level], "must exist"
  end

  test "can have multiple compensation records" do
    CompensationRecord.create!(
      employee: @employee,
      currency: Currency.create!(
        code: "USD",
        name: "US Dollar",
        symbol: "$"
      ),
      annual_base_salary: BigDecimal("80000.00"),
      effective_from: Date.new(2024, 1, 1),
      effective_to: Date.new(2024, 12, 31)
    )

    CompensationRecord.create!(
      employee: @employee,
      currency: Currency.create!(
        code: "EUR",
        name: "Euro",
        symbol: "€"
      ),
      annual_base_salary: BigDecimal("85000.00"),
      effective_from: Date.new(2025, 1, 1)
    )

    assert_equal 2, @employee.compensation_records.count
  end

  test "prevents deleting an employee with compensation records" do
    CompensationRecord.create!(
      employee: @employee,
      currency: Currency.create!(
        code: "USD",
        name: "US Dollar",
        symbol: "$"
      ),
      annual_base_salary: BigDecimal("80000.00"),
      effective_from: Date.new(2024, 1, 1)
    )

    assert_raises(ActiveRecord::DeleteRestrictionError) do
      @employee.destroy!
    end

    assert Employee.exists?(@employee.id)
  end
end
