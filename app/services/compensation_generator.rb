class CompensationGenerator
  SALARY_INCREASE = BigDecimal("1.05")

  SALARY_BANDS = {
    "IN" => {
      "Junior" => 600_000,
      "Mid" => 1_000_000,
      "Senior" => 1_600_000,
      "Lead" => 2_200_000,
      "Principal" => 3_000_000
    },
    "US" => {
      "Junior" => 70_000,
      "Mid" => 100_000,
      "Senior" => 140_000,
      "Lead" => 175_000,
      "Principal" => 220_000
    },
    "GB" => {
      "Junior" => 35_000,
      "Mid" => 50_000,
      "Senior" => 70_000,
      "Lead" => 90_000,
      "Principal" => 120_000
    },
    "DE" => {
      "Junior" => 40_000,
      "Mid" => 55_000,
      "Senior" => 75_000,
      "Lead" => 95_000,
      "Principal" => 125_000
    },
    "CA" => {
      "Junior" => 60_000,
      "Mid" => 85_000,
      "Senior" => 115_000,
      "Lead" => 145_000,
      "Principal" => 180_000
    },
    "AU" => {
      "Junior" => 65_000,
      "Mid" => 90_000,
      "Senior" => 120_000,
      "Lead" => 150_000,
      "Principal" => 185_000
    }
  }.freeze

  CURRENCY_CODES = {
    "IN" => "INR",
    "US" => "USD",
    "GB" => "GBP",
    "DE" => "EUR",
    "CA" => "CAD",
    "AU" => "AUD"
  }.freeze

  def self.generate
    new.generate
  end

  def initialize
    @currencies = Currency.all.index_by(&:code)
  end

  def generate
    raise "Reference data is missing" if @currencies.empty?

    Employee.order(:id).find_each do |employee|
      generate_for(employee)
    end
  end

  private

  def generate_for(employee)
    return if employee.compensation_records.exists?
    return if employee.joining_date > Date.current

    current_start = employee.joining_date
    salary = starting_salary_for(employee)
    currency = currency_for(employee)
    today = Date.current

    while current_start < today
      next_start = [ current_start.next_year, today ].min

      CompensationRecord.create!(
        employee: employee,
        currency: currency,
        annual_base_salary: salary.round(2),
        effective_from: current_start,
        effective_to: next_start
      )

      current_start = next_start
      salary *= SALARY_INCREASE
    end

    CompensationRecord.create!(
      employee: employee,
      currency: currency,
      annual_base_salary: salary.round(2),
      effective_from: current_start,
      effective_to: nil
    )
  end

  def starting_salary_for(employee)
    country_code = employee.country.iso_code
    SALARY_BANDS.fetch(country_code).fetch(employee.job_level.name)
  end

  def currency_for(employee)
    currency_code = CURRENCY_CODES.fetch(employee.country.iso_code)
    @currencies.fetch(currency_code)
  end
end
