class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :IDno
      t.string :department
      t.integer :maths
      t.integer :physics
      t.integer :chemistry
      t.integer :year

      t.timestamps
    end
  end
end
