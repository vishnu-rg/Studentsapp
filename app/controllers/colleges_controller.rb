class CollegesController < ApplicationController
	def index
	  	@colleges = College.all
	  	Rails.logger.debug "In sssssssssssssssssss: #{params.inspect}"
	  	#@collegesh = College.find(params[:id])
	end

	def show
	 	@college = College.find(params[:id])
	end

	def new
	  	@colleges = College.new
	end

	def edit
	  	@colleges = College.find(params[:id])
	end

	def listing
		gaga = College.find(params[:format])
		Rails.logger.debug "Updatinpppppppppppppppppppgggggggggggggg Record #{gaga.inspect}"

		@pass = gaga.student
		Rails.logger.debug "Updatinggggggggggggggggggggggggg Record #{@pass.inspect}"
	end

	def update
	  	@colleges =College.find(params[:id])
	  	@colleges.update_attributes(params[:colleges])
	  	redirect_to action: :index
	end

	def create
	  	@colleges = College.create(params[:colleges])
	  	redirect_to action: :index
	end

	def destroy
	  	@colleges = College.find(params[:id])
	  	@colleges.destroy
	  	redirect_to action: :index
	end

	def search
	  	
	end

	def results
	  	data = College.all
	  	Rails.logger.debug "Updatinggggggggggggggggggggggggg Record #{params.inspect}"
	  	Rails.logger.debug "Updatinggggggggggggggggggggggggg Record #{data.inspect}"
	  	input = params[:temp][:vars].to_s
	  	
	  	@my_string = Array.new
	  	for i in 0..(data.length-1)
	  		
			if data[i][:college_name].include? input
			@my_string.push(data[i])
			end
			Rails.logger.debug "Updatinggggggggggggggggggggggggg Record #{@my_string.inspect}"

		end
	end
end
