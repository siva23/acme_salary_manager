require "test_helper"

class CurrencyTest < ActiveSupport::TestCase
  test "is valid with a code and name" do
    currency = Currency.new(code: "USD", name: "US Dollar", symbol: "$")

    assert currency.valid?
  end

  test "requires a code" do
    currency = Currency.new(name: "US Dollar")

    assert_not currency.valid?
    assert_includes currency.errors[:code], "can't be blank"
  end

  test "requires a name" do
    currency = Currency.new(code: "USD")

    assert_not currency.valid?
    assert_includes currency.errors[:name], "can't be blank"
  end

  test "requires a unique code" do
    Currency.create!(code: "USD", name: "US Dollar")
    duplicate = Currency.new(code: "USD", name: "Another Dollar")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:code], "has already been taken"
  end
end