class Api::V1::CompensationRecordsController < ApplicationController
  def index
    employee = Employee.includes(:department, :job_level, :country).find(params[:employee_id])
    compensation_records = employee.compensation_records.includes(:currency).order(:effective_from)

    render json: {
      employee: {
        id: employee.id,
        employee_number: employee.employee_number,
        first_name: employee.first_name,
        last_name: employee.last_name,
        job_title: employee.job_title,
        department: employee.department.name,
        job_level: employee.job_level.name,
        country: employee.country.name
      },
      compensation: compensation_records.map do |record|
        {
          id: record.id,
          annual_base_salary: record.annual_base_salary.to_s,
          currency: {
            code: record.currency.code,
            name: record.currency.name,
            symbol: record.currency.symbol
          },
          effective_from: record.effective_from,
          effective_to: record.effective_to
        }
      end
    }
  end
end