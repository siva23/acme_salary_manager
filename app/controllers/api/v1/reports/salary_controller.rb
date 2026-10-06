class Api::V1::Reports::SalaryController < ApplicationController
  def index
    reports = ::Reports::SalaryReport.new.call

    render json: {
      reports: reports
    }
  end
end
