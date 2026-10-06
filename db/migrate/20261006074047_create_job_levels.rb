class CreateJobLevels < ActiveRecord::Migration[8.1]
  def change
    create_table :job_levels do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :job_levels, :name, unique: true
  end
end
