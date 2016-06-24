namespace :my_namespace do
	desc "TODO"
	task :updating_extendedid => :environment do
	  	students = Student.all
	  	students.each do |k|
	  		if k.IDno != nil && k.extendedId == nil
	  			k.extendedId = k.func_extendedsid
	  			k.save
	  		end
	  	end
	end
end
