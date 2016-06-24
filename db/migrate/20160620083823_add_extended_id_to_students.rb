class AddExtendedIdToStudents < ActiveRecord::Migration
  def change
    add_column :students, :extendedId, :string
  end
end
