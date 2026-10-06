require "test_helper"

class SalaryReportTest < ActiveSupport::TestCase
  setup do
    @india = Country.create!(name: "India", iso_code: "IN")
    @engineering = Department.create!(name: "Engineering")
    @senior = JobLevel.create!(name: "Senior")
    @inr = Currency.create!(code: "INR", name: "Indian Rupee", symbol: "₹")

    @usd = Currency.create!(
      code: "USD",
      name: "US Dollar",
      symbol: "$"
    )

    @usa = Country.create!(
      name: "Test United States",
      iso_code: "ZZ"
    )

    @employee_one = Employee.create!(
      employee_number: "EMP-1001",
      first_name: "John",
      last_name: "Doe",
      email: "john@example.com",
      country: @india,
      department: @engineering,
      job_level: @senior,
      job_title: "Senior Software Engineer",
      employment_status: "active",
      joining_date: Date.new(2020, 1, 1)
    )

    @employee_two = Employee.create!(
      employee_number: "EMP-1002",
      first_name: "Jane",
      last_name: "Doe",
      email: "jane@example.com",
      country: @india,
      department: @engineering,
      job_level: @senior,
      job_title: "Senior Software Engineer",
      employment_status: "active",
      joining_date: Date.new(2020, 1, 1)
    )

    @employee_three = Employee.create!(
      employee_number: "EMP-1003",
      first_name: "Bob",
      last_name: "Smith",
      email: "bob@example.com",
      country: @usa,
      department: @engineering,
      job_level: @senior,
      job_title: "Senior Software Engineer",
      employment_status: "active",
      joining_date: Date.new(2020, 1, 1)
    )

    CompensationRecord.create!(
      employee: @employee_one,
      currency: @inr,
      annual_base_salary: 2_000_000,
      effective_from: Date.new(2025, 1, 1),
      effective_to: Date.new(2026, 1, 1)
    )

    CompensationRecord.create!(
      employee: @employee_one,
      currency: @inr,
      annual_base_salary: 3_000_000,
      effective_from: Date.new(2026, 1, 1)
    )

    CompensationRecord.create!(
      employee: @employee_two,
      currency: @inr,
      annual_base_salary: 4_000_000,
      effective_from: Date.new(2026, 1, 1)
    )

    CompensationRecord.create!(
      employee: @employee_three,
      currency: @usd,
      annual_base_salary: 100_000,
      effective_from: Date.new(2026, 1, 1)
    )
  end

  test "reports current salary statistics grouped by country, department and currency" do
    report = Reports::SalaryReport.new.call

    assert_equal 2, report.length

    row = report.first

    assert_equal "India", row[:country]
    assert_equal "Engineering", row[:department]
    assert_equal "INR", row[:currency]
    assert_equal 2, row[:employee_count]
    assert_equal BigDecimal("3500000.0"), row[:average_salary]
    assert_equal BigDecimal("3000000.0"), row[:minimum_salary]
    assert_equal BigDecimal("4000000.0"), row[:maximum_salary]

    usd_row = report.find { |row| row[:currency] == "USD" }

    assert_equal "Test United States", usd_row[:country]
    assert_equal "Engineering", usd_row[:department]
    assert_equal 1, usd_row[:employee_count]
    assert_equal BigDecimal("100000.0"), usd_row[:average_salary]
  end
end
