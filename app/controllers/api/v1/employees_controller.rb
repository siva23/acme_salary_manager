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
      employees: employees.map do |employee|
        {
          id: employee.id,
          employee_number: employee.employee_number,
          first_name: employee.first_name,
          last_name: employee.last_name,
          email: employee.email,
          job_title: employee.job_title,
          employment_status: employee.employment_status,
          joining_date: employee.joining_date,
          country: {
            id: employee.country.id,
            name: employee.country.name,
            iso_code: employee.country.iso_code
          },
          department: {
            id: employee.department.id,
            name: employee.department.name
          },
          job_level: {
            id: employee.job_level.id,
            name: employee.job_level.name
          }
        }
      end,
      pagination: {
        page: page,
        per_page: per_page,
        total: total,
        total_pages: (total.to_f / per_page).ceil
      }
    }
  end

  def show
    employee = Employee.includes(:country, :department, :job_level).find(params[:id])

    render json: {
			id: employee.id,
			employee_number: employee.employee_number,
			first_name: employee.first_name,
			last_name: employee.last_name,
			email: employee.email,
			job_title: employee.job_title,
			employment_status: employee.employment_status,
			joining_date: employee.joining_date,
			country: {
				id: employee.country.id,
				name: employee.country.name,
				iso_code: employee.country.iso_code
			},
			department: {
				id: employee.department.id,
				name: employee.department.name
			},
			job_level: {
				id: employee.job_level.id,
				name: employee.job_level.name
			}
    }
  end
end
