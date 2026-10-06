class Employee < ApplicationRecord
  belongs_to :country
  belongs_to :department
  belongs_to :job_level

  validates :employee_number, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :job_title, presence: true
  validates :employment_status, presence: true, inclusion: {
    in: %w[active inactive terminated]
  }
  validates :joining_date, presence: true
end
