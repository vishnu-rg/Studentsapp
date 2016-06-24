class Student < ActiveRecord::Base
  attr_accessible :IDno, :chemistry, :department, :maths, :physics, :year, :college_id, :extendedId
    belongs_to :college

    before_create :func_extendedsid1

    before_update :func_extendedsid

    def func_extendedsid
    	 
    	student_id = self.IDno.to_s
    	college_twoletters = College.find(self.college_id)[:college_name][0,2]
    	collegeId = self.college_id.to_s
    	self.extendedId = student_id << "_" << college_twoletters << "_" << collegeId
    	
    end

    def func_extendedsid1
    	 
    	student_id = self.IDno.to_s
    	college_twoletters = College.find(self.college_id)[:college_name][0,2]
    	collegeId = self.college_id.to_s
    	self.extendedId = student_id << "_" << college_twoletters << "_" << collegeId
    	
    end
end


#Rails.logger.debug "Updatinppp2222222222gggggggggggggg Record #{student_id.inspect}"