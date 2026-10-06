class CompensationRecord < ApplicationRecord
  belongs_to :employee
  belongs_to :currency

  validates :annual_base_salary, presence: true,
    numericality: { greater_than: 0 }

  validates :effective_from, presence: true

  validate :effective_to_after_effective_from

  private

  def effective_to_after_effective_from
    return if effective_from.blank? || effective_to.blank?

    return if effective_to > effective_from

    errors.add(:effective_to, "must be after effective from")
  end
end