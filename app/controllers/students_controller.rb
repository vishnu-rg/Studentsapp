class StudentsController < ApplicationController
  
	def index
	  	@students = Student.all
	end

	def show	  
		@student = Student.find(params[:id])
		respond_to do |format|
			format.json do
			    render json: @student.to_json
			end

			format.html do
			end
		end
	end

	def new
	  	@students = Student.new
	end

	def edit
	  	@students = Student.find(params[:id])
	end

	def update
	  	@student = Student.find(params[:id])
	  	@student.update_attributes(params["students"])
	  	redirect_to action: :index
	end

	def destroy
	  	@student = Student.find(params[:id])
	  	@student.destroy
	  	redirect_to action: :index
	end

	def create
	  	@students = Student.create(params[:students])
	  	redirect_to action: :new
	end

	def find_by
		
	end

	def doquery
	  	
	end

	def queries
	  	data = Student.all
	  	datatable_cpy= Array.new
	  	data_db= Array.new
	  	datatable_another_cpy = Array.new

	  	for i in 0..(data.length-1)
	  		datatable_cpy[i] = {:IDno=>data[i].IDno, :department=>data[i].department, :maths=>data[i].maths, :physics=>data[i].physics, :chemistry=>data[i].chemistry, :year=>data[i].year }
	  	end

	  	for i in 0..(data.length-1)
	  		data_db[i]= {:IDno=>data[i].IDno, :department=>data[i].department, :maths=>data[i].maths, :physics=>data[i].physics, :chemistry=>data[i].chemistry, :year=>data[i].year }
	  	end

	    for i in 0..(data.length-1)
	  		datatable_another_cpy[i] = { :IDno=>data[i].IDno, :department=>data[i].department, :maths=>data[i].maths, :physics=>data[i].physics, :chemistry=>data[i].chemistry, :year=>data[i].year }
	  	end
	  	
	  	grouping(params[:groupby],datatable_cpy,datatable_another_cpy)
	  	sorting(params[:sortby],params[:groupby])
	  	@grpby_id_dept_year = params[:groupby]
	  	compare(params[:compareby])
	  	total_show(data_db)
	end

    def group_keys(array)
		keyy = array[0].keys
		keyy.delete(:maths)
		keyy.delete(:physics)
		keyy.delete(:chemistry)
		return keyy
	end
		
 	def grouping(groupby,array_arg,array)
		keyy = group_keys(array)
		@mean_hash=Hash.new
		grouped_array = Hash.new
		
		keyy.each do |n| 
			if n.to_s == groupby.to_s
				grouped_array = array_arg.group_by{|h| h[n.to_sym]}
				grouped_array.each_key do |k|
					for i in 0..(grouped_array[k].length-1)
				 		grouped_array[k][i].delete(:IDno)
				 		grouped_array[k][i].delete(:department)
				 		grouped_array[k][i].delete(:year)
				 	end 	
				end

				grouped_array.each_key do |k|
					average_values = grouped_array[k].map(&:values).transpose.map { |arr| 
					arr.map(&:to_f).inject(:+) / arr.size 
																		 }
					with_keys = Hash[grouped_array[k].first.keys.zip(average_values)]
					@mean_hash[k]=with_keys
				end
			end			
		end
	end
	
	def sorting(sortby,groupby)
		meanhash_to_arr_of_hashes = Array.new
		mean_arr = Array.new
		mean_arr_values = Array.new
		mean_arr_keys = Array.new
		temp = Hash.new
		@sorted = []
		mean_arr_values = @mean_hash.values
		mean_arr_keys   = @mean_hash.keys

		for i in 0..(mean_arr_keys.length-1)
			temp[groupby.to_sym] = mean_arr_keys[i]
			mean_arr_values[i] = temp.merge(mean_arr_values[i])
			meanhash_to_arr_of_hashes[i] = mean_arr_values[i]
		end
		mean_arr = @mean_hash.values[0].keys
		mean_arr.each do |p|
			if p.to_s == sortby.to_s
				@sorted = meanhash_to_arr_of_hashes.sort_by{|p| p[sortby.to_sym]}
			end
		end
	end

    def compare(id_dept)
		data = Student.all
		arr_cpy = Array.new
		for i in 0..(data.length-1)
	  		arr_cpy[i]= {:IDno=>data[i].IDno, :department=>data[i].department, :maths=>data[i].maths, :physics=>data[i].physics, :chemistry=>data[i].chemistry, :year=>data[i].year }
	  	end

	  	past_year=2015
			current_year=2016

		if id_dept == "IDno"
			new_array=arr_cpy.group_by{|h| h[:year]}
			year_length=new_array.length
			past_data=new_array[past_year.to_i].group_by{|h| h[:IDno]}
			current_data=new_array[current_year.to_i].group_by{|h| h[:IDno]}
            current_print=Hash.new
			past_print=Hash.new
			if(current_data.length>past_data.length)
				current_data.each_key do |k|
					if(!current_data.key?(k))
						temp=[{:year1=>current_year,:maths1=>0,:physics1=>0,:chemistry1=>0},{:year1=>past_year,:maths1=>past_data[k][0][:maths],:physics1=>past_data[k][0][:physics],:chemistry1=>past_data[k][0][:chemistry]},{:change=>"change",:maths1=>"infinity",:physics1=>"infinity",:chemistry1=>"infinity"}]
			        	current_print[k]=temp
			        elsif(!past_data.key?(k))
						temp=[{:year1=>current_year,:maths1=>current_data[k][0][:maths],:physics1=>current_data[k][0][:physics],:chemistry1=>current_data[k][0][:chemistry]},{:year1=>past_year,:maths1=>0,:physics1=>0,:chemistry1=>0},{:change=>"change",:maths1=>100,:physics1=>100,:chemistry1=>100}]
			        	current_print[k]=temp
			        else
						temp=[{:year1=>current_year,:maths1=>current_data[k][0][:maths],:physics1=>current_data[k][0][:physics],:chemistry1=>current_data[k][0][:chemistry]},{:year1=>past_year,:maths1=>past_data[k][0][:maths],:physics1=>past_data[k][0][:physics],:chemistry1=>past_data[k][0][:chemistry]},{:change=>"change",:maths1=>((current_data[k][0][:maths]-past_data[k][0][:maths]).to_f*100/current_data[k][0][:maths].to_f).round(2),:physics1=>((current_data[k][0][:physics]-past_data[k][0][:physics]).to_f*100/current_data[k][0][:physics].to_f).round(2),:chemistry1=>((current_data[k][0][:chemistry]-past_data[k][0][:chemistry]).to_f*100/current_data[k][0][:chemistry].to_f).round(2)}]
						current_print[k]=temp
					end
			    end
				@output_compared = current_print
			else
				past_data.each_key do |k|
					if(!current_data.key?(k))
						temp=[{:year1=>current_year,:maths1=>0,:physics1=>0,:chemistry1=>0},{:year1=>past_year,:maths1=>past_data[k][0][:maths],:physics1=>past_data[k][0][:physics],:chemistry1=>past_data[k][0][:chemistry]},{:change=>"change",:maths1=>"infinity",:physics1=>"infinity",:chemistry1=>"infinity"}]
			        	current_print[k]=temp
			        elsif(!past_data.key?(k))
						temp=[{:year1=>current_year,:maths1=>current_data[k][0][:maths],:physics1=>current_data[k][0][:physics],:chemistry1=>current_data[k][0][:chemistry]},{:year1=>past_year,:maths1=>0,:physics1=>0,:chemistry1=>0},{:change=>"change",:maths1=>100,:physics1=>100,:chemistry1=>100}]
			        	current_print[k]=temp
			        else
						temp=[{:year1=>current_year,:maths1=>current_data[k][0][:maths],:physics1=>current_data[k][0][:physics],:chemistry1=>current_data[k][0][:chemistry]},{:year1=>past_year,:maths1=>past_data[k][0][:maths],:physics1=>past_data[k][0][:physics],:chemistry1=>past_data[k][0][:chemistry]},{:change=>"change",:maths1=>((current_data[k][0][:maths]-past_data[k][0][:maths]).to_f*100/current_data[k][0][:maths].to_f).round(2),:physics1=>((current_data[k][0][:physics]-past_data[k][0][:physics]).to_f*100/current_data[k][0][:physics].to_f).round(2),:chemistry1=>((current_data[k][0][:chemistry]-past_data[k][0][:chemistry]).to_f*100/current_data[k][0][:chemistry].to_f).round(2)}]
						current_print[k]=temp
					end
			    end
				@output_compared = current_print
			end
		elsif id_dept == "department"
			grpby_year = arr_cpy.group_by{|h| h[:year]} 
			@final = Hash.new
			current_data = grpby_year[current_year].group_by{|h| h[:department]}
			past_data = grpby_year[past_year].group_by{|h| h[:department]}
			current_data.each_key do |k|
				c_data_len = current_data[k].size
				math_sum = 0;phy_sum = 0; chem_sum = 0;
				for i in 0..(c_data_len-1)
					math_sum = math_sum + current_data[k][i][:maths].to_f
					phy_sum = phy_sum + current_data[k][i][:physics].to_f
					chem_sum = chem_sum + current_data[k][i][:chemistry].to_f
				end
				@avg_current_year[k] = {:maths=> (math_sum/c_data_len).round(2), :physics=> (phy_sum/c_data_len).round(2), :chemistry=>(chem_sum/c_data_len).round(2), :year=>current_year }
				p_data_len = past_data[k].size
				math_sum = 0;phy_sum = 0; chem_sum = 0;
				for i in 0..(p_data_len-1)
					math_sum = math_sum + past_data[k][i][:maths].to_f
					phy_sum = phy_sum + past_data[k][i][:physics].to_f
					chem_sum = chem_sum + past_data[k][i][:chemistry].to_f
				end
				@avg_past_year[k] = {:maths=> (math_sum/p_data_len).round(2), :physics=> (phy_sum/p_data_len).round(2), :chemistry=>(chem_sum/p_data_len).round(2), :year=>past_year }
								
			end
			@avg_past_year.each_key {|k|
				math_avg_dept = percent_change(@avg_current_year[k][:maths],@avg_past_year[k][:maths])
				phys_avg_dept = percent_change(@avg_current_year[k][:physics],@avg_past_year[k][:physics])
				chem_avg_dept = percent_change(@avg_current_year[k][:chemistry],@avg_past_year[k][:chemistry])
				@current_print[k] = {:maths=> math_avg_dept, :physics=>  phys_avg_dept, :chemistry=> chem_avg_dept, :change=>"change"}
			}
			@output_compared = @current_print
		else
			@output_compared = "No comparison"
		end
	end

	def percent_change(first_entry,second_entry) 
		if second_entry == 0
    		return 100
    	elsif first_entry == 0
    		return "infinity"
    	else 
    		return ((first_entry - second_entry).to_f * 100/first_entry.to_f).round(2)	
    	end
    end

    def total_show(data)
		@sum_hash = Array.new
		data_grouped_sum = Hash.new
		data_grouped_sum_values=Array.new
		mean_arr_values = Array.new
		data_grouped_sum_keys = Array.new
		sumhash_to_arr_of_hashes=Array.new
		for i in 0..(data.length-1)
			data[i].delete(:IDno)
			data[i].delete(:department)
		end
		data = data.group_by{|k| k[:year]}
		data.each_key do |s|
			average_values = data[s].map(&:values).transpose.map { |arr| 
			arr.map(&:to_f).inject(:+) / 1 
																 }
			with_keys = Hash[data[s].first.keys.zip(average_values)]
			data_grouped_sum[s] = with_keys
		end
		data_grouped_sum.each_key do |h|
			data_grouped_sum[h].delete(:year)
		end
		data_grouped_sum_values = data_grouped_sum.values
		data_grouped_sum_keys   = data_grouped_sum.keys
		for i in 0..(data_grouped_sum_keys.length-1)
			temp = Hash.new
			temp[:year] = data_grouped_sum_keys[i]
			data_grouped_sum_values[i] = temp.merge(data_grouped_sum_values[i])
		end
		@sumhash_to_arr_of_hashes = data_grouped_sum_values
	end
end












=begin
  private
  def Students_params
  	params.require(:Students).permit(:IDn0, :department, :maths,:physics ,:chemistry,:year)
  end
 end
 #def Students_params
 #	params.require(:Students).permit(:IDno, :department, :maths, :physics, :chemistry, :year)
 #end

 
  
end


		<%= form_for @Students do |k| %>
		<%=  k.label :IDno %>
		<%=  k.text_field :IDno %>

		<%=  k.label :department%>
		<%=  k.text_field :department%>

		<%=  k.label :maths %>
		<%=  k.text_field :maths %>

		<%=  k.label :physics %>
		<%=  k.text_field :physics %>

		<%=  k.label :chemistry %>
		<%=  k.text_field :chemistry %>

		<%=  k.label :year %>
		<%=  k.text_field :year %>

		<%= k.submit %>
		<% end %>


		def new
  	@Students = Student.new
  end

  def create
  	@Students = Student.create(Students_params)
  	redirect_to action: :index
  end

	private

	def Students_params
		params.require(:Students).permit(:IDno, :department, :maths, :physics, :chemistry, :year)
	end
	<%= link_to "New Link", :controller => :links, :action => :new %>
		    <td><%= link_to "edit" ,Students_path(Students) %></td>
	    <td><%= link_to "delete" ,Students_path(Students) %></td>

=end





















=begin


class Students
	@@array = [{:id=>1, :department=>"a1", :maths=>43, :physics=>54, :chemistry=>65, :year=>2016},{:id=>2, :department=>"a1", :maths=>66, :physics=>52, :chemistry=>65, :year=>2016},{:id=>3, :department=>"a7", :maths=>87, :physics=>32, :chemistry=>43, :year=>2016},{:id=>1, :department=>"a1", :maths=>21, :physics=>52, :chemistry=>65, :year=>2015},{:id=>2, :department=>"a1", :maths=>68, :physics=>50, :chemistry=>65, :year=>2015},{:id=>3, :department=>"a7", :maths=>85, :physics=>22, :chemistry=>43, :year=>2015},{:id=>4, :department=>"a7", :maths=>21, :physics=>22, :chemistry=>13, :year=>2016}]
	@@data = [{:id=>1, :department=>"a1", :maths=>43, :physics=>54, :chemistry=>65, :year=>2016},{:id=>2, :department=>"a1", :maths=>66, :physics=>52, :chemistry=>65, :year=>2016},{:id=>3, :department=>"a7", :maths=>87, :physics=>32, :chemistry=>43, :year=>2016},{:id=>1, :department=>"a1", :maths=>21, :physics=>52, :chemistry=>65, :year=>2015},{:id=>2, :department=>"a1", :maths=>68, :physics=>50, :chemistry=>65, :year=>2015},{:id=>3, :department=>"a7", :maths=>85, :physics=>22, :chemistry=>43, :year=>2015},{:id=>4, :department=>"a7", :maths=>21, :physics=>22, :chemistry=>13, :year=>2016}]

	def group_keys()
		@keyy = @@array[0].keys
		#puts @keyy
		@keyy.delete(:maths)
		@keyy.delete(:physics)
		@keyy.delete(:chemistry)
	end
	
 	def grouping(a)
		group_keys
		#puts @keyy
		@mean_hash=Hash.new
		grouped_array = Hash.new
		@keyy.each{|n| 
			#print n 
			#puts a
			if n.to_s == a.to_s
				grouped_array = @@array.group_by{|h| h[n.to_sym]}
				#puts grouped_array
				grouped_array.each_key{|k|
				for i in 0..(grouped_array[k].length-1)
			 		grouped_array[k][i].delete(:id)
			 		grouped_array[k][i].delete(:department)
			 		grouped_array[k][i].delete(:year)
			 	end 	
							 }

				grouped_array.each_key{|k|
				average_values = grouped_array[k].map(&:values).transpose.map { |arr| 
				arr.map(&:to_f).inject(:+) / arr.size 
																	 }
				with_keys = Hash[grouped_array[k].first.keys.zip(average_values)]
				@mean_hash[k]=with_keys
							 }
			end
				
				 }
				 if @mean_hash.length != 0
				 	puts @mean_hash
				 else 
				 	puts "type one of these"
				 end
			
	end
	
	def sorting(b,groupby)
		arr1 = Array.new
		arr = Array.new
		arr_values = Array.new
		arr_keys = Array.new
		temp = Hash.new
		@sorted = []
		arr_values = @mean_hash.values
		arr_keys   = @mean_hash.keys
		for i in 0..(arr_keys.length-1)
			#puts c
			temp[groupby.to_sym] = arr_keys[i]
			arr_values[i] = temp.merge(arr_values[i])
			#temp << arr_values[c]
			#puts arr_values[i]
			arr1[i] = arr_values[i]
		end
			arr = @mean_hash.values[0].keys
			#puts arr
			arr.each{|p|
			#puts p
			if p.to_s == b.to_s
				@sorted = arr1.sort_by{|p| p[b.to_sym]}
			end
			    }
			    if @sorted.length != 0
			    	puts @sorted
			    else
			    	puts "type one of these"
			    end
	end

	def display(input)
		if input == "yes"
			dup = @sorted[0].keys
			dup.each{|j|
				print "#{j}\t\t"
			}
			puts
		#puts "Maths\t\tPhysics\t\tChemistry"
		@sorted.each{|k|
			dup.each{|m|
			print "#{k[m.to_sym].round(2)}\t\t "}
			puts
		} 
		else 
			puts "go to comparison question"
		end
	end

	def compare(c)
		if c == "yes"
			puts "type year"
			past_year=gets.chomp
			puts "type year"
			current_year=gets.chomp
			new_array=@@data.group_by{|h| h[:year]}
			year_length=new_array.length
			#puts new_array
			past_data=new_array[past_year.to_i].group_by{|h| h[:id]}
			current_data=new_array[current_year.to_i].group_by{|h| h[:id]}

			current_print=Hash.new
			past_print=Hash.new

			if(current_data.length>past_data.length)
				current_data.each_key{|k|

					if(!current_data.key?(k))
						temp=[{:year1=>current_year,:maths1=>0,:physics1=>0,:chemistry1=>0},{:year1=>past_year,:maths1=>past_data[k][0][:maths],:physics1=>past_data[k][0][:physics],:chemistry1=>past_data[k][0][:chemistry]},{:change=>"change",:maths1=>"infinity",:physics1=>"infinity",:chemistry1=>"infinity"}]
			        	cusrrent_print[k]=temp


					elsif(!past_data.key?(k))
						temp=[{:year1=>current_year,:maths1=>current_data[k][0][:maths],:physics1=>current_data[k][0][:physics],:chemistry1=>current_data[k][0][:chemistry]},{:year1=>past_year,:maths1=>0,:physics1=>0,:chemistry1=>0},{:change=>"change",:maths1=>100,:physics1=>100,:chemistry1=>100}]
			        	current_print[k]=temp


					else
						temp=[{:year1=>current_year,:maths1=>current_data[k][0][:maths],:physics1=>current_data[k][0][:physics],:chemistry1=>current_data[k][0][:chemistry]},{:year1=>past_year,:maths1=>past_data[k][0][:maths],:physics1=>past_data[k][0][:physics],:chemistry1=>past_data[k][0][:chemistry]},{:change=>"change",:maths1=>(current_data[k][0][:maths]-past_data[k][0][:maths]).to_f*100/current_data[k][0][:maths].to_f,:physics1=>(current_data[k][0][:physics]-past_data[k][0][:physics]).to_f*100/current_data[k][0][:physics].to_f,:chemistry1=>(current_data[k][0][:chemistry]-past_data[k][0][:chemistry]).to_f*100/current_data[k][0][:chemistry].to_f}]
						current_print[k]=temp
					end
			                   }
				puts current_print
			else
				past_data.each_key{|k|

					if(!current_data.key?(k))
						temp=[{:year1=>current_year,:maths1=>0,:physics1=>0,:chemistry1=>0},{:year1=>past_year,:maths1=>past_data[k][0][:maths],:physics1=>past_data[k][0][:physics],:chemistry1=>past_data[k][0][:chemistry]},{:change=>"change",:maths1=>"infinity",:physics1=>"infinity",:chemistry1=>"infinity"}]
			        	current_print[k]=temp


					elsif(!past_data.key?(k))
						temp=[{:year1=>current_year,:maths1=>current_data[k][0][:maths],:physics1=>current_data[k][0][:physics],:chemistry1=>current_data[k][0][:chemistry]},{:year1=>past_year,:maths1=>0,:physics1=>0,:chemistry1=>0},{:change=>"change",:maths1=>100,:physics1=>100,:chemistry1=>100}]
			        	current_print[k]=temp


					else
						temp=[{:year1=>current_year,:maths1=>current_data[k][0][:maths],:physics1=>current_data[k][0][:physics],:chemistry1=>current_data[k][0][:chemistry]},{:year1=>past_year,:maths1=>past_data[k][0][:maths],:physics1=>past_data[k][0][:physics],:chemistry1=>past_data[k][0][:chemistry]},{:change=>"change",:maths1=>(current_data[k][0][:maths]-past_data[k][0][:maths]).to_f*100/current_data[k][0][:maths].to_f,:physics1=>(current_data[k][0][:physics]-past_data[k][0][:physics]).to_f*100/current_data[k][0][:physics].to_f,:chemistry1=>(current_data[k][0][:chemistry]-past_data[k][0][:chemistry]).to_f*100/current_data[k][0][:chemistry].to_f}]
						current_print[k]=temp
					end
			                   }
				puts current_print
			end
		elsif c == "no"
			puts "No comparison"
		else
			puts "type yes/no"
		end
	end

end

puts "groupby:? id/department/year"
groupby = gets.chomp
object = Student.new
object.grouping(groupby)
puts "sortby:maths/physics/chemistry"
sortby = gets.chomp
object.sorting(sortby,groupby)
puts "display:? yes/no"
displayby = gets.chomp
object.display(displayby)
puts "Do you want comparison"
compareby = gets.chomp
object.compare(compareby)




grp_newarr.each_key{|q|
				for i in 0..(grp_newarr[q].length-1)
			 		
			 		grp_newarr[q][i].delete(:year)
			 		
			 	end 	
							 }
			grp_newarr.each_key{|s|
				average_values = grp_newarr[s].map(&:values).transpose.map { |arr| 
				arr.map(&:to_f).inject(:+) / arr.size 
																	 }
				with_keys = Hash[grp_newarr[s].first.keys.zip(average_values)]
				@grp_mean_hash[s]=with_keys
							 }




		}
		year_grp.each_key{|m|
		temp = year_grp[m]

=end


