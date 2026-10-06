class Api::V1::DepartmentsController < ApplicationController
  def index
    departments = Department.order(:name)

    render json: {
      departments: departments.map do |department|
        {
          id: department.id,
          name: department.name
        }
      end
    }
  end
end