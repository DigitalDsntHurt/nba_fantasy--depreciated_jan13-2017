class PlayerPool < ApplicationRecord
	
	#validates :player_id, presence: true
	#before_validation :get_player_id
	#after_create :get_player_id, :output
	before_create :get_player_id
	after_create :update_players_most_recent_salary

	require 'csv'
	def self.import(file)

	    clean_sheet = []
		row_counter = 0

		first = ""
		File.read(file.path).each_line{|line|
			@first = line.split(",")[0].gsub("\"","").downcase
			first += @first if @first.include?("position")
		}
		#first = line.split(",")[0].gsub("\"","").downcase

		if first.include?("position")
			f = File.read(file.path)

			headers = []
			count = 0
			f.each_line{|line|
				if count == 0
					line.split(",").map{|l| l.gsub("\"","").downcase.strip }.each{|h|
						headers << h.to_sym
					}
				end 
				count += 1
			}

			headers.insert(-2,:avg_fppg)
			headers.delete(:avgpointspergame)
			headers.insert(-3,:game_info)
			headers.delete(:gameinfo)
			headers.insert(-1,:team)
			headers.delete(:teamabbrev)
			p headers

			payload = []

			count = 0
			f.each_line{|line|
				if count > 0
					@row = {}
					line.split(",").each_with_index{|cell,i|
						if headers[i] == :salary
							@row[headers[i]] = cell.strip.gsub("\"","").to_i
						elsif headers[i] == :avg_fppg
							@row[headers[i]] = cell.strip.gsub("\"","").to_f
						else
							@row[headers[i]] = cell.strip.gsub("\"","")
						end


					}
					payload << @row
				end
				count += 1
			}

			payload.sort_by{|hsh| hsh["salary"]}.each{|row|
				PlayerPool.create!(row)
			}			
		else
			File.read(file.path).each_line{|line|
				row_counter += 1
				next if row_counter < 9
				clean_row = line[9..-1].split(",")[0..-2]
				#clean_row.delete_at(3)
				clean_sheet << clean_row
			}

			# array to store our hashes
			payload = []
			# define headers
			headers = ["position", "name_and_id", "name", "id", "salary", "game_info", "team"]
			clean_sheet.each{|row|
				# create a hash for each row
				@hsh = {}
				# loop through each cell in the row
				row.each_with_index{|cell,i| #[0..-2]
					key = headers[i]
					# create a new k,v pair where k = the header and v = the cell contents
					@hsh[key] = cell
				}
				# save the hash containing the cell's contents to the payload array
				payload << @hsh
			}

			# Create new db records from the array of hashes we just created
			payload.map{|hsh| hsh.reject{ |k,v| k == "id" } }.sort_by{|hsh| hsh["salary"]}.each{|row|
				PlayerPool.create!(row)
			}
		end

	end


	protected

	def get_player_id
		player_match = Player.where(name: self.name).to_a
		if player_match.count == 1 and player_match[0].class == Player and p self.position.include?(player_match[0].position) 
			self.player_id = player_match[0].id.to_s
		end
	end

	def update_players_most_recent_salary
		#p Player.where(id: self.player_id)[0]
		#p Player.where(id: self.player_id).to_a
		if self.player_id != nil
			Player.where(id: self.player_id)[0].update!(salary: self.salary)
		end
	end



=begin
=end
		


end
