class RemoveCollegeNameFromStudents < ActiveRecord::Migration
  def up
    remove_column :students, :college_name
  end

  def down
    add_column :students, :college_name, :string
  end
end
