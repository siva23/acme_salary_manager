class Api::V1::CountriesController < ApplicationController
  def index
    countries = Country.order(:name)

    render json: {
      countries: countries.map do |country|
        {
          id: country.id,
          name: country.name,
          iso_code: country.iso_code
        }
      end
    }
  end
end
