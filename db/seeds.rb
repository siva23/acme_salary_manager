# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

countries = [
  { name: "India", iso_code: "IN" },
  { name: "United States", iso_code: "US" },
  { name: "United Kingdom", iso_code: "GB" },
  { name: "Germany", iso_code: "DE" },
  { name: "Canada", iso_code: "CA" },
  { name: "Australia", iso_code: "AU" }
]

countries.each do |attributes|
  Country.find_or_create_by!(iso_code: attributes[:iso_code]) do |country|
    country.name = attributes[:name]
  end
end

departments = [
  "Engineering",
  "Product",
  "Finance",
  "Human Resources",
  "Sales",
  "Operations"
]

departments.each do |name|
  Department.find_or_create_by!(name: name)
end

job_levels = [
  "Junior",
  "Mid",
  "Senior",
  "Lead",
  "Principal"
]

job_levels.each do |name|
  JobLevel.find_or_create_by!(name: name)
end

currencies = [
  { code: "INR", name: "Indian Rupee", symbol: "₹" },
  { code: "USD", name: "US Dollar", symbol: "$" },
  { code: "EUR", name: "Euro", symbol: "€" },
  { code: "GBP", name: "British Pound", symbol: "£" },
  { code: "CAD", name: "Canadian Dollar", symbol: "C$" },
  { code: "AUD", name: "Australian Dollar", symbol: "A$" }
]

currencies.each do |attributes|
  Currency.find_or_create_by!(code: attributes[:code]) do |currency|
    currency.name = attributes[:name]
    currency.symbol = attributes[:symbol]
  end
end