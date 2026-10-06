module Reports
  class HeadcountReport
    def call
      Employee
        .joins(:country, :department)
        .group(
          "countries.name",
          "departments.name"
        )
        .order(
          "countries.name",
          "departments.name"
        )
        .pluck(
          "countries.name",
          "departments.name",
          "COUNT(employees.id)"
        )
        .map do |country, department, employee_count|
          {
            country: country,
            department: department,
            employee_count: employee_count
          }
        end
    end
  end
end
