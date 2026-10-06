class Country < ApplicationRecord
	validates :name, presence: true
  validates :iso_code, presence: true, uniqueness: true
end
