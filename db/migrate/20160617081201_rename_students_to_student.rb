class RenameStudentsToStudent < ActiveRecord::Migration
  def change
  	rename_table :students, :student
  end
end
