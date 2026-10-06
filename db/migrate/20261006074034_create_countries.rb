class CreateCountries < ActiveRecord::Migration[8.1]
  def change
    create_table :countries do |t|
      t.string :name, null: false
      t.string :iso_code, null: false, limit: 2

      t.timestamps
    end

    add_index :countries, :iso_code, unique: true
  end
end
