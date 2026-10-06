class Api::V1::EmployeesController < ApplicationController
  DEFAULT_PER_PAGE = 25
  MAX_PER_PAGE = 100

  def index
    page = params.fetch(:page, 1).to_i
    per_page = [params.fetch(:per_page, DEFAULT_PER_PAGE).to_i, MAX_PER_PAGE].min

    employees = Employee
      .includes(:country, :department, :job_level)
      .order(:id)
      .offset((page - 1) * per_page)
      .limit(per_page)

    total = Employee.count

    render json: {
      employees: employees,
      pagination: {
        page: page,
        per_page: per_page,
        total: total,
        total_pages: (total.to_f / per_page).ceil
      }
    }
  end
end
