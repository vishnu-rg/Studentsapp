class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :college_name
      t.integer :esta_year

      t.timestamps
    end
  end
end
