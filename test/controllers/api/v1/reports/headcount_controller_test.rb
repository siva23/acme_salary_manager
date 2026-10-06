require "test_helper"

class HeadcountControllerTest < ActionDispatch::IntegrationTest
  setup do
    @india = Country.create!(
      name: "Test India",
      iso_code: "ZZ"
    )

    @engineering = Department.create!(
      name: "Test Engineering"
    )

    @senior = JobLevel.create!(
      name: "Test Senior"
    )

    Employee.create!(
      employee_number: "EMP-4001",
      first_name: "John",
      last_name: "Doe",
      email: "john4001@example.com",
      country: @india,
      department: @engineering,
      job_level: @senior,
      job_title: "Senior Software Engineer",
      employment_status: "active",
      joining_date: Date.new(2020, 1, 1)
    )
  end

  test "returns headcount report" do
    get "/api/v1/reports/headcount"

    assert_response :success

    body = JSON.parse(response.body)

    assert body.key?("reports")
    assert_kind_of Array, body["reports"]
  end
end
