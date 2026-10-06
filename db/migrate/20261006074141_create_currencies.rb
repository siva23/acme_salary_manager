class CreateCurrencies < ActiveRecord::Migration[8.1]
  def change
    create_table :currencies do |t|
      t.string :code, null: false, limit: 3
      t.string :name, null: false
      t.string :symbol

      t.timestamps
    end

    add_index :currencies, :code, unique: true
  end
end
