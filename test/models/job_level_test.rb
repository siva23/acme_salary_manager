require "test_helper"

class JobLevelTest < ActiveSupport::TestCase
  test "is valid with a name" do
    job_level = JobLevel.new(name: "Senior")

    assert job_level.valid?
  end

  test "requires a name" do
    job_level = JobLevel.new

    assert_not job_level.valid?
    assert_includes job_level.errors[:name], "can't be blank"
  end

  test "requires a unique name" do
    JobLevel.create!(name: "Senior")
    duplicate = JobLevel.new(name: "Senior")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end
end
