require "test_helper"

class EmployeeGeneratorTest < ActiveSupport::TestCase
  setup do
    @employee_count = Employee.count
  end

  test "generates the requested number of employees" do
    assert_difference("Employee.count", 10) do
      EmployeeGenerator.generate(count: @employee_count + 10)
    end
  end

  test "does not generate duplicate employees when target count already exists" do
    EmployeeGenerator.generate(count: @employee_count + 10)

    assert_no_difference("Employee.count") do
      EmployeeGenerator.generate(count: @employee_count + 10)
    end
  end

  test "continues employee numbering when increasing the target count" do
    EmployeeGenerator.generate(count: @employee_count + 5)

    EmployeeGenerator.generate(count: @employee_count + 8)

    assert Employee.exists?(employee_number: "EMP-0001")
    assert Employee.exists?(employee_number: format("EMP-%04d", @employee_count + 8))
  end

  test "generates unique employee numbers and emails" do
    EmployeeGenerator.generate(count: @employee_count + 10)

    employees = Employee.order(:id).last(10)

    assert_equal 10, employees.map(&:employee_number).uniq.count
    assert_equal 10, employees.map(&:email).uniq.count
  end

  test "distributes employees across reference data" do
    EmployeeGenerator.generate(count: @employee_count + 12)

    employees = Employee.order(:id).last(12)

    assert_operator employees.map(&:country_id).uniq.count, :>, 1
    assert_operator employees.map(&:department_id).uniq.count, :>, 1
    assert_operator employees.map(&:job_level_id).uniq.count, :>, 1
  end
end
