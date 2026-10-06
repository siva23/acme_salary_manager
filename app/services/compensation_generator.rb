class CompensationGenerator
  SALARY_INCREASE = BigDecimal("1.10")
  BASE_SALARY = BigDecimal("50000")
  SALARY_INCREMENT = BigDecimal("2500")

  def self.generate
    new.generate
  end

  def generate
    currencies = Currency.order(:id).to_a

    raise "Reference data is missing" if currencies.empty?

    Employee.order(:id).find_each.with_index do |employee, index|
      generate_for(employee, currencies, index)
    end
  end

  private

  def generate_for(employee, currencies, index)
    return if employee.compensation_records.exists?

    current_start = employee.joining_date
    salary = starting_salary_for(index)
    today = Date.current
    return if employee.joining_date > today

    currency = currencies[index % currencies.length]

    while current_start < today
      next_start = [current_start.next_year, today].min

      CompensationRecord.create!(
        employee: employee,
        currency: currency,
        annual_base_salary: salary,
        effective_from: current_start,
        effective_to: next_start
      )

      current_start = next_start
      salary *= SALARY_INCREASE
    end

    CompensationRecord.create!(
      employee: employee,
      currency: currency,
      annual_base_salary: salary,
      effective_from: current_start,
      effective_to: nil
    )
  end

  def starting_salary_for(index)
    BASE_SALARY + (index * SALARY_INCREMENT)
  end
end
