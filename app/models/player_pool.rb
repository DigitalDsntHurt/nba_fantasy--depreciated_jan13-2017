class PlayerPool < ApplicationRecord
	
	#validates :player_id, presence: true
	#before_validation :get_player_id
	#after_create :get_player_id, :output
	before_create :get_player_id

	require 'csv'
	def self.import(file)
	    clean_sheet = []
		row_counter = 0
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


	protected

	def get_player_id
		
		player_match = Player.where(name: self.name).to_a
		#p player_match.name
		#p self.name
		if player_match.count == 1 and player_match[0].class == Player and p self.position.include?(player_match[0].position) 
				#self.player_id = player_match[0].id if player_match[0].id.class != NilClass
				puts "=============="
				puts "=============="
				puts "=============="
				puts "=============="
				puts "=============="
				puts "=============="
				p self.name
				p self.position
				p player_match[0].name
				p player_match[0].position
				p player_match[0].id
				self.player_id = player_match[0].id.to_s
				puts "=============="
				puts "=============="
				puts "=============="
				puts "=============="
				puts "=============="
				puts "=============="
			#end
		end
	end

=begin
=end
		


end
