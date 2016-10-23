




#if PlayerPool.all.count > 1
Rufus::Scheduler.new.every '30s', :first_in => '1s' do
puts "============ BEGIN SCHEDULER ============"

	###
	###
	###
		num_lineups = 200
		num_generations = 2
		salary_cap = 50000
	###
	###
	###

	# Get Eligible Players
	playerpool = PlayerPool.all
	players = []
	playerpool.each{|pp|
		if pp.player_id != nil
			players << Player.where(id: pp.player_id)[0]
		end
	}
	players.sort_by!{|p| -p.fps}.uniq!

# Create First Generation
	generation = []
	num_lineups.times do |num|

		initial_lineup = {}
		
		i = players.index{ |p| p.position.include?("PG") }
		next if i == nil
		initial_lineup[:pg] = players[i]
		players.delete_at(i)

		i = players.index{ |p| p.position.include?("SG") }
		next if i == nil
		initial_lineup[:sg] = players[i]
		players.delete_at(i)

		i = players.index{ |p| p.position.include?("SF") }
		next if i == nil
		initial_lineup[:sf] = players[i]
		players.delete_at(i)

		i = players.index{ |p| p.position.include?("PF") }
		next if i == nil
		initial_lineup[:pf] = players[i]
		players.delete_at(i)

		i = players.index{ |p| p.position.include?("C") }
		next if i == nil
		initial_lineup[:c] = players[i]
		players.delete_at(i)

		i = players.index{ |p| p.position.include?("G") }
		next if i == nil
		initial_lineup[:g] = players[i]
		players.delete_at(i)

		i = players.index{ |p| p.position.include?("F") }
		next if i == nil
		initial_lineup[:f] = players[i]
		players.delete_at(i)

		next if i == nil
		initial_lineup[:util] = players[0]
		players.delete_at(i)

		total_salary = 0
		total_fps = 0
		initial_lineup.each{|k,v|
			total_salary += v.salary
			total_fps += v.fps
		}

		
		until total_salary < salary_cap
			# randomly select half the player positions
			change_group = initial_lineup.keys.combination(initial_lineup.keys.length/2).to_a[rand(0..initial_lineup.keys.combination(initial_lineup.keys.length/2).to_a.count)]
			change_group.each{|position|
				
				i = players.index{ |p| p.position.include?(position.to_s.upcase) }
				next if i == nil
				# Add position player back into players
				players << initial_lineup[position]
				# Set new position player
				initial_lineup[position] = players[i]
				# Delete newly added player from players
				players.delete_at(i)
				# Recalculate total salary
				total_salary = 0
				initial_lineup.each{|k,v|
					total_salary += v.salary
				}
				break if total_salary < salary_cap
			}
		end

		initial_lineup[:total_salary] = total_salary
		initial_lineup[:total_fps] = total_fps

		break if players.length == 0
		generation << initial_lineup
	end

	#
	puts generation.count

	# Create Subsequent Generations
	num_generations.times do |num|
		
		(0..generation.length-1).each do |gen_num|
			
			@new_lineup = generation[gen_num].clone

			# Get a fresh set of eligible Players
			@playerpool = PlayerPool.all
			@players = []
			@playerpool.each{|pp|
				if pp.player_id != nil
					@players << Player.where(id: pp.player_id)[0]
				end
			}
			@players.sort_by!{|p| -p.fps}.uniq!
			
			# 
			@change_group = @new_lineup.keys[0..7].combination(@new_lineup.keys[0..7].length/2).to_a[rand(0..@new_lineup.keys[0..7].combination(@new_lineup.keys[0..7].length/2).to_a.count)]
			@change_group.each_with_index{|position,position_index|
				#until total_salary >= salary_cap
					#@cap_dif = 
					i = @players.index{ |p| p.position.include?(position.to_s.upcase) }
					next if i == nil
					@current_player = @new_lineup[position]
					@swap_player = @players[i]
					num = i + 1 
					until @urrent_player != @swap_player
						@swap_player = @players[num]
						num + 1
					end
					#end
					
					# Add position player back into players
					@players << @current_player
					# Set new position player
					@new_lineup[position] = @swap_player
					# Delete newly added player from players
					@players.delete_at(i)
					
					# Recalculate total salary
					total_salary = 0
					@new_lineup.each{|k,v|
						next if k == :total_salary or k == :total_fps
						total_salary += v.salary
					}
					break if total_salary >= salary_cap
				#end
			}
			generation << @new_lineup
		end
		puts generation.count
	end


	generation.uniq.sort_by{|hsh| -hsh[:total_fps]}.each{|l|
		p l
		puts 
	}

	puts generation.class
	puts generation.count
	puts generation.uniq.count



=begin
=end
payload = []
@uptime = Time.now
generation.uniq.each{|hsh|
	@hsh = {}
	@hsh[:pg] = hsh[:pg].name
	@hsh[:sg] = hsh[:sg].name
	@hsh[:sf] = hsh[:sf].name
	@hsh[:pf] = hsh[:pf].name
	@hsh[:c] = hsh[:c].name
	@hsh[:g] = hsh[:g].name
	@hsh[:f] = hsh[:f].name
	@hsh[:util] = hsh[:util].name
	@hsh[:expected_fp] = hsh[:total_fps]
	@hsh[:salary] = hsh[:total_salary]
	@hsh[:expected_updated] = @uptime
	payload << @hsh
}

payload.uniq.each{|lineup|
	Lineup.create!(lineup)
}

final_model = {:pg => [], :sg => [], :sf => [], :pf => [], :c => [], :g => [], :f => [], :util => [], :total_salary => 0, :total_fps => 0}
puts "============ END SCHEDULER ============"
end #scheduler
#end # mega if 










