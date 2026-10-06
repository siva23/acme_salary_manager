module Reports
  class SalaryReport
    def call
      CompensationRecord
        .joins(employee: [ :country, :department ])
        .joins(:currency)
        .where(effective_to: nil)
        .group(
          "countries.name",
          "departments.name",
          "currencies.code"
        )
        .order(
          "countries.name",
          "departments.name",
          "currencies.code"
        )
        .pluck(
          "countries.name",
          "departments.name",
          "currencies.code",
          "COUNT(compensation_records.id)",
          "AVG(compensation_records.annual_base_salary)",
          "MIN(compensation_records.annual_base_salary)",
          "MAX(compensation_records.annual_base_salary)"
        )
        .map do |country, department, currency, employee_count, average_salary, minimum_salary, maximum_salary|
          {
            country: country,
            department: department,
            currency: currency,
            employee_count: employee_count,
            average_salary: average_salary,
            minimum_salary: minimum_salary,
            maximum_salary: maximum_salary
          }
        end
    end
  end
end
