require "test_helper"

class CountryTest < ActiveSupport::TestCase
  test "is valid with a name and ISO code" do
    country = Country.new(name: "India", iso_code: "IN")

    assert country.valid?
  end

  test "requires a name" do
    country = Country.new(iso_code: "IN")

    assert_not country.valid?
    assert_includes country.errors[:name], "can't be blank"
  end

  test "requires an ISO code" do
    country = Country.new(name: "India")

    assert_not country.valid?
    assert_includes country.errors[:iso_code], "can't be blank"
  end

  test "requires a unique ISO code" do
    Country.create!(name: "India", iso_code: "IN")
    duplicate = Country.new(name: "Another India", iso_code: "IN")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:iso_code], "has already been taken"
  end
end
