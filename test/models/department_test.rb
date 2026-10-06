require "test_helper"

class DepartmentTest < ActiveSupport::TestCase
  test "is valid with a name" do
    department = Department.new(name: "Engineering")

    assert department.valid?
  end

  test "requires a name" do
    department = Department.new

    assert_not department.valid?
    assert_includes department.errors[:name], "can't be blank"
  end

  test "requires a unique name" do
    Department.create!(name: "Engineering")
    duplicate = Department.new(name: "Engineering")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end
end
