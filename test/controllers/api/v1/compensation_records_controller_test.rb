require "test_helper"

class Api::V1::CompensationRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @country = Country.create!(name: "India", iso_code: "IN")
    @department = Department.create!(name: "Engineering")
    @job_level = JobLevel.create!(name: "Senior")
    @currency = Currency.create!(
      code: "INR",
      name: "Indian Rupee",
      symbol: "₹"
    )

    @employee = Employee.create!(
      employee_number: "EMP-0001",
      first_name: "John",
      last_name: "Smith",
      email: "john@example.com",
      country: @country,
      department: @department,
      job_level: @job_level,
      job_title: "Senior Software Engineer",
      employment_status: "active",
      joining_date: Date.new(2020, 1, 1)
    )

    @first_record = CompensationRecord.create!(
      employee: @employee,
      currency: @currency,
      annual_base_salary: 50000,
      effective_from: Date.new(2020, 1, 1),
      effective_to: Date.new(2021, 1, 1)
    )

    @current_record = CompensationRecord.create!(
      employee: @employee,
      currency: @currency,
      annual_base_salary: 55000,
      effective_from: Date.new(2021, 1, 1),
      effective_to: nil
    )
  end

  test "returns employee information and compensation history" do
    get "/api/v1/employees/#{@employee.id}/compensation_records"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal(
      {
        "id" => @employee.id,
        "employee_number" => @employee.employee_number,
        "first_name" => @employee.first_name,
        "last_name" => @employee.last_name,
        "job_title" => @employee.job_title,
        "department" => @department.name,
        "job_level" => @job_level.name,
        "country" => @country.name
      },
      body["employee"]
    )

    assert_equal 2, body["compensation"].length

    assert_equal(
      {
        "id" => @first_record.id,
        "annual_base_salary" => "50000.0",
        "currency" => {
          "code" => "INR",
          "name" => "Indian Rupee",
          "symbol" => "₹"
        },
        "effective_from" => "2020-01-01",
        "effective_to" => "2021-01-01"
      },
      body["compensation"].first
    )
  end

  test "returns compensation history in chronological order" do
    get "/api/v1/employees/#{@employee.id}/compensation_records"

    assert_response :success

    body = JSON.parse(response.body)

    effective_dates = body["compensation"].map { |record| record["effective_from"] }

    assert_equal [ "2020-01-01", "2021-01-01" ], effective_dates
  end

  test "returns not found for an unknown employee" do
    get "/api/v1/employees/999999/compensation_records"

    assert_response :not_found
  end
end
