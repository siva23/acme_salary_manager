class AddCompensationPeriodExclusionConstraint < ActiveRecord::Migration[8.1]
  def change
    enable_extension "btree_gist"

    add_exclusion_constraint :compensation_records,
      "employee_id WITH =, daterange(effective_from, COALESCE(effective_to, 'infinity'::date), '[)') WITH &&",
      using: :gist,
      name: "compensation_records_no_overlapping_periods"
  end
end