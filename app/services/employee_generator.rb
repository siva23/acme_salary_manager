class EmployeeGenerator
  STATUSES = %w[active inactive terminated].freeze

  FIRST_NAMES = %w[
    John
    Jane
    Michael
    Sarah
    David
    Emily
    Robert
    Olivia
    Daniel
    Sophia
  ].freeze

  LAST_NAMES = %w[
    Smith
    Johnson
    Brown
    Williams
    Jones
    Miller
    Davis
    Wilson
    Taylor
    Anderson
  ].freeze

  def self.generate(count:)
    new(count: count).generate
  end

  def initialize(count:)
    @count = count
  end

  def generate
    countries = Country.order(:id).to_a
    departments = Department.order(:id).to_a
    job_levels = JobLevel.order(:id).to_a

    raise "Reference data is missing" if countries.empty? ||
                                        departments.empty? ||
                                        job_levels.empty?

    existing_count = Employee.count

    return [] if existing_count >= @count

    start_number = Employee.maximum(:employee_number)&.delete_prefix("EMP-")&.to_i || 0

    (@count - existing_count).times.map do |offset|
      number = start_number + offset + 1

      Employee.create!(
        employee_number: format("EMP-%04d", number),
        first_name: FIRST_NAMES[(number - 1) % FIRST_NAMES.length],
        last_name: LAST_NAMES[(number - 1) % LAST_NAMES.length],
        email: format("employee%04d@example.com", number),
        country: countries[(number - 1) % countries.length],
        department: departments[(number - 1) % departments.length],
        job_level: job_levels[(number - 1) % job_levels.length],
        job_title: job_title_for(job_levels[(number - 1) % job_levels.length]),
        employment_status: STATUSES[(number - 1) % STATUSES.length],
        joining_date: Date.new(2018, 1, 1) + ((number - 1) * 30)
      )
    end
  end

  private

  def job_title_for(job_level)
    "#{job_level.name} Software Engineer"
  end
end