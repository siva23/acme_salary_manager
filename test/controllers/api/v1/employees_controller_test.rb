require "test_helper"

class Api::V1::EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @country = Country.create!(name: "India", iso_code: "IN")
    @department = Department.create!(name: "Engineering")
    @job_level = JobLevel.create!(name: "Senior")

    30.times do |index|
      Employee.create!(
        employee_number: format("EMP-%04d", index + 1),
        first_name: "First#{index + 1}",
        last_name: "Last#{index + 1}",
        email: "employee#{index + 1}@example.com",
        country: @country,
        department: @department,
        job_level: @job_level,
        job_title: "Senior Software Engineer",
        employment_status: "active",
        joining_date: Date.new(2020, 1, 1)
      )
    end
  end

  test "returns the first page with the default page size" do
    get "/api/v1/employees"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal 25, body["employees"].length
    assert_equal 1, body["pagination"]["page"]
    assert_equal 25, body["pagination"]["per_page"]
    assert_equal 30, body["pagination"]["total"]
    assert_equal 2, body["pagination"]["total_pages"]
  end

  test "returns the requested page and page size" do
    get "/api/v1/employees?page=2&per_page=10"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal 10, body["employees"].length
    assert_equal 2, body["pagination"]["page"]
    assert_equal 10, body["pagination"]["per_page"]
  end

  test "caps per page at the maximum" do
    get "/api/v1/employees?per_page=500"

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal 100, body["pagination"]["per_page"]
    assert_equal 30, body["employees"].length
  end

  test "returns an employee with related information" do
    employee = Employee.first
    get "/api/v1/employees/#{employee.id}"

    assert_response :success

    body = JSON.parse(response.body)
    expected_hash = {
      "id" => employee.id,
      "employee_number" => employee.employee_number,
      "first_name" => employee.first_name,
      "last_name" => employee.last_name,
      "email" => employee.email,
      "job_title" => employee.job_title,
      "employment_status" => employee.employment_status,
      "joining_date" => employee.joining_date.to_s,
      "country" => {
        "id" => employee.country.id,
        "name" => employee.country.name,
        "iso_code" => employee.country.iso_code
      },
      "department" => {
        "id" => employee.department.id,
        "name" => employee.department.name
      },
      "job_level" => {
        "id" => employee.job_level.id,
        "name" => employee.job_level.name
      }
    }

    assert_equal expected_hash, body
  end

  test "returns not found for an unknown employee" do
    get "/api/v1/employees/999999"

    assert_response :not_found
  end
end
