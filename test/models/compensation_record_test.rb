require "test_helper"

class CompensationRecordTest < ActiveSupport::TestCase
  setup do
    @country = Country.create!(name: "India", iso_code: "IN")
    @department = Department.create!(name: "Engineering")
    @job_level = JobLevel.create!(name: "Senior")
    @currency = Currency.create!(
      code: "USD",
      name: "US Dollar",
      symbol: "$"
    )

    @employee = Employee.create!(
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
    )

    @compensation_attributes = {
      employee: @employee,
      currency: @currency,
      annual_base_salary: BigDecimal("100000.00"),
      effective_from: Date.new(2026, 1, 1),
      effective_to: nil
    }
  end

  test "is valid with all required attributes" do
    compensation = CompensationRecord.new(@compensation_attributes)

    assert compensation.valid?
  end

  test "requires an employee" do
    compensation = CompensationRecord.new(
      @compensation_attributes.except(:employee)
    )

    assert_not compensation.valid?
    assert_includes compensation.errors[:employee], "must exist"
  end

  test "requires a currency" do
    compensation = CompensationRecord.new(
      @compensation_attributes.except(:currency)
    )

    assert_not compensation.valid?
    assert_includes compensation.errors[:currency], "must exist"
  end

  test "requires an annual base salary" do
    compensation = CompensationRecord.new(
      @compensation_attributes.except(:annual_base_salary)
    )

    assert_not compensation.valid?
    assert_includes compensation.errors[:annual_base_salary], "can't be blank"
  end

  test "requires annual base salary to be greater than zero" do
    compensation = CompensationRecord.new(
      @compensation_attributes.merge(annual_base_salary: 0)
    )

    assert_not compensation.valid?
    assert compensation.errors[:annual_base_salary].any?
  end

  test "requires an effective from date" do
    compensation = CompensationRecord.new(
      @compensation_attributes.except(:effective_from)
    )

    assert_not compensation.valid?
    assert_includes compensation.errors[:effective_from], "can't be blank"
  end

  test "allows a blank effective to date for current compensation" do
    compensation = CompensationRecord.new(
      @compensation_attributes.merge(effective_to: nil)
    )

    assert compensation.valid?
  end

  test "requires effective to to be after effective from" do
    compensation = CompensationRecord.new(
      @compensation_attributes.merge(
        effective_to: Date.new(2025, 12, 31)
      )
    )

    assert_not compensation.valid?
    assert_includes compensation.errors[:effective_to],
      "must be after effective from"
  end

  test "accepts an effective to date after effective from" do
    compensation = CompensationRecord.new(
      @compensation_attributes.merge(
        effective_to: Date.new(2026, 12, 31)
      )
    )

    assert compensation.valid?
  end
end