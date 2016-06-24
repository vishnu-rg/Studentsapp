class AddCollege < ActiveRecord::Migration
  def change
  	add_column :students, :college_id, :integer
  end

end
