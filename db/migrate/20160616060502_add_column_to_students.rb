class AddColumnToStudents < ActiveRecord::Migration
  def change
    add_column :students, :college_name, :string
  end
end
