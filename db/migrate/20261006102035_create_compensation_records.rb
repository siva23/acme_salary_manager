class CreateCompensationRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :compensation_records do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :currency, null: false, foreign_key: true

      t.decimal :annual_base_salary, precision: 15, scale: 2, null: false
      t.date :effective_from, null: false
      t.date :effective_to

      t.timestamps
    end

    add_index :compensation_records, [:employee_id, :effective_from]
  end
end