require "test_helper"

class Api::V1::CountriesControllerTest < ActionDispatch::IntegrationTest
  test "returns countries ordered by name" do
    get "/api/v1/countries"

    assert_response :success

    body = JSON.parse(response.body)

    names = body["countries"].map { |country| country["name"] }

    assert_equal names.sort, names
  end
end
