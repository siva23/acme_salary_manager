require "test_helper"

class Api::V1::DepartmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @engineering = Department.create!(name: "Engineering")
    @finance = Department.create!(name: "Finance")
    @product = Department.create!(name: "Product")
  end

  test "returns departments ordered by name" do
    get "/api/v1/departments"

    assert_response :success

    body = JSON.parse(response.body)

    names = body["departments"].map { |department| department["name"] }

    assert_equal names.sort, names
  end
end
