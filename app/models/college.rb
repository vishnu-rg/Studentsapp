class College < ActiveRecord::Base
	attr_accessible :college_name, :esta_year
	has_many :student
	before_update :clg_namechange
	students_changedcollege = Array.new

  	def clg_namechange
  		Rails.logger.debug "Updatinppp2222222222gggggggggggggg Record #{self.college_name.inspect}"
  		students_list = College.find(self.id.to_i).student
  		#Rails.logger.debug "Updatinppp2222222222gggggggggggggg Record #{students_changedcollege.inspect}"
  		for i in 0..(students_list.length-1)

	 		students_list[i][:extendedId] = students_list[i][:id].to_s << "_" << self.college_name[0,2].to_s << "_" << self.id.to_s
	 		#College.find(self.id.to_i).student[i].save
	 		#Rails.logger.debug "Updatinppp2222222222gggggggggggggg Record #{College.find(self.id.to_i).student[i].extendedId.inspect}"

	 		Rails.logger.debug "Updatinppp2222222222gggggggggggggg Record #{students_list[i].inspect}"
	 	end
	end
end
