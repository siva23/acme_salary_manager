require "test_helper"

class SalaryControllerTest < ActionDispatch::IntegrationTest
  setup do
    @india = Country.create!(name: "Test India", iso_code: "ZZ")
    @engineering = Department.create!(name: "Test Engineering")
    @senior = JobLevel.create!(name: "Test Senior")
    @inr = Currency.create!(
      code: "TST",
      name: "Test Currency",
      symbol: "T"
    )

    @employee_one = Employee.create!(
      employee_number: "EMP-2001",
      first_name: "John",
      last_name: "Doe",
      email: "john2001@example.com",
      country: @india,
      department: @engineering,
      job_level: @senior,
      job_title: "Senior Software Engineer",
      employment_status: "active",
      joining_date: Date.new(2020, 1, 1)
    )

    @employee_two = Employee.create!(
      employee_number: "EMP-2002",
      first_name: "Jane",
      last_name: "Doe",
      email: "jane2002@example.com",
      country: @india,
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
  end

  test "returns salary report" do
    get "/api/v1/reports/salary"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal 1, body["reports"].length

    report = body["reports"].first

    assert_equal "Test India", report["country"]
    assert_equal "Test Engineering", report["department"]
    assert_equal "TST", report["currency"]
    assert_equal 2, report["employee_count"]
    assert_equal "3500000.0", report["average_salary"]
    assert_equal "3000000.0", report["minimum_salary"]
    assert_equal "4000000.0", report["maximum_salary"]
  end
end