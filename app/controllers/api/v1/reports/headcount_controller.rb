class Api::V1::Reports::HeadcountController < ApplicationController
  def index
    reports = ::Reports::HeadcountReport.new.call

    render json: {
      reports: reports
    }
  end
end
