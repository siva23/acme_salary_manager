require "test_helper"

class HeadcountReportTest < ActiveSupport::TestCase
  setup do
    @india = Country.create!(
      name: "Test India",
      iso_code: "ZZ"
    )

    @usa = Country.create!(
      name: "Test United States",
      iso_code: "ZY"
    )

    @engineering = Department.create!(
      name: "Test Engineering"
    )

    @finance = Department.create!(
      name: "Test Finance"
    )

    @senior = JobLevel.create!(
      name: "Test Senior"
    )

    @employees = [
      {
        employee_number: "EMP-3001",
        first_name: "John",
        last_name: "Doe",
        email: "john3001@example.com",
        country: @india,
        department: @engineering
      },
      {
        employee_number: "EMP-3002",
        first_name: "Jane",
        last_name: "Doe",
        email: "jane3002@example.com",
        country: @india,
        department: @engineering
      },
      {
        employee_number: "EMP-3003",
        first_name: "Bob",
        last_name: "Smith",
        email: "bob3003@example.com",
        country: @india,
        department: @finance
      },
      {
        employee_number: "EMP-3004",
        first_name: "Alice",
        last_name: "Smith",
        email: "alice3004@example.com",
        country: @usa,
        department: @engineering
      }
    ].map do |attributes|
      Employee.create!(
        **attributes,
        job_level: @senior,
        job_title: "Senior Software Engineer",
        employment_status: "active",
        joining_date: Date.new(2020, 1, 1)
      )
    end
  end

  test "reports headcount grouped by country and department" do
    report = Reports::HeadcountReport.new.call

    assert_equal 3, report.length

    india_engineering = report.find do |row|
      row[:country] == "Test India" &&
        row[:department] == "Test Engineering"
    end

    assert_equal 2, india_engineering[:employee_count]

    india_finance = report.find do |row|
      row[:country] == "Test India" &&
        row[:department] == "Test Finance"
    end

    assert_equal 1, india_finance[:employee_count]

    usa_engineering = report.find do |row|
      row[:country] == "Test United States" &&
        row[:department] == "Test Engineering"
    end

    assert_equal 1, usa_engineering[:employee_count]
  end
end
