##
#### Generate lineups w/ maximized expected fantasy points under a salary cap
##

Rufus::Scheduler.new.every '30s', :first_in => '1s' do
	# if there are players in the pool and 
	# if there are no stored lineups
	if PlayerPool.all.count > 1 and Lineup.all.count < 1
	puts "============ BEGIN SCHEDULED LINEUP SELECTION ============"
		
		#
		##
		## ### ### ### ### ### ### ### ### ### ##
		## ### ### ### ### ### ### ### ### ### ##
		## Set the # of generations to run	   ##
		   num_generations = 2  			   ##
							   				   ##		
		## Set the number of lineups desired   ##
		   num_lineups = 200 				   ##
							   				   ##		   
		## set the salary cap 				   ##
			salary_cap = 50000	        	   ##
							   				   ##
		## ### ### ### ### ### ### ### ### ### ##
		## ### ### ### ### ### ### ### ### ### ##
		##
		#


		# Get Eligible Players
		playerpool = PlayerPool.all
		players = []
		playerpool.each{|pp|
			players << Player.where(id: pp.player_id)[0] if pp.player_id != nil #|| pp.salary != nil
		}
		players.sort_by!{|p| -p.fps}.uniq!
=begin
		puts "=============="
		puts players.count
		puts "=============="

		players.each do |p|
			p p
		end	
=end		
		def calculate_total_salary(lineup)
			salary = 0
			lineup.each{|k,v|
				salary += v.salary unless k == :salary or k == :expected_fp
			}
			return salary
		end

		def calculate_total_efps(lineup)
			efps = 0.0
			lineup.each{|k,v|
				efps += v.fps unless k == :salary or k == :expected_fp
			}
			return efps
		end

		def calculate_total_afps(lineup)
			afps = 0.0
			lineup.each{|k,v|
				afps += v.afps unless k == :total_salary or k == :total_fps
			}
			return afps
		end

		def legal?(lineup)
			if calculate_total_salary(lineup) > 50000
				return false
			else
				return true
			end
		end
=begin
=end
############ BEGIN LINEUP SELECTION METHOD ############
generations = []

### CREATE FIRST GENERATION ###


# num_generations.times do |gen_num|
	generation = []
	used = []
	num_lineups.times do |lineup_num|

		lineup = {}

		# util
		lineup[:util] = players[0]
		#players.delete(players[0])
		used << players[0]

		# guards
		i = players.index{ |p| p.position.include?("G") }
		lineup[:g] = players[i]
		#players.delete_at(i)
		used << players[i]

		# pgs
		i = players.index{ |p| p.position.include?("PG") }
		lineup[:pg] = players[i]
		#players.delete_at(i)
		used << players[i]

		# sgs
		i = players.index{ |p| p.position.include?("SG") }
		lineup[:sg] = players[i]
		#players.delete_at(i)
		used << players[i]

		# forwards
		i = players.index{ |p| p.position.include?("F") }
		lineup[:f] = players[i]
		#players.delete_at(i)
		used << players[i]

		# sfs
		i = players.index{ |p| p.position.include?("SF") }
		lineup[:sf] = players[i]
		#players.delete_at(i)
		used << players[i]

		# fps
		i = players.index{ |p| p.position.include?("PF") }
		lineup[:pf] = players[i]
		#players.delete_at(i)
		used << players[i]

		# cs
		i = players.index{ |p| p.position.include?("C") }
		lineup[:c] = players[i]
		#players.delete_at(i)
		used << players[i]

		lineup[:salary] = calculate_total_salary(lineup)
		lineup[:expected_fp] = calculate_total_efps(lineup)

		## Make it legal
		if not legal?(lineup)
			position_combos = lineup.keys[1..-3].combination(rand(3..4)).to_a
			change_group = position_combos[rand(0..position_combos.length-1)]
			change_group.each{|pos|
				old_player = lineup[pos]
				swap_player = players.select{|p| p.position.include?(pos.to_s.upcase)}.reject{|p| p.salary >= old_player.salary }[rand(0..1)]
				#players << old_player
				lineup[pos] = swap_player
				used << swap_player

				lineup[:salary] = calculate_total_salary(lineup)
				lineup[:expected_fp] = calculate_total_efps(lineup)
			}
		end

		generation << lineup

		break if players.select{ |p| p.position.include?("PG") }.count <= 1
		break if players.select{ |p| p.position.include?("SG") }.count <= 1
		break if players.select{ |p| p.position.include?("PF") }.count <= 1
		break if players.select{ |p| p.position.include?("SF") }.count <= 1
		break if players.select{ |p| p.position.include?("C") }.count <= 1
	end # num_lineups.times
	generations << generation
#end # number generations



### CREATE SUBSEQUENT GENERATIONS ###
if num_generations > 1
	# subsequent generations
end
### END SUBSEQUENT GENERATIONS ###

############ END LINEUP SELECTION METHOD ############



###### CREATE LINEUP ROWS ######
payload = []
generations.each{|gen|
	gen.each{|l|
		@hsh = {}
		l.each{|k,v|
			if k == :salary or k == :expected_fp
				@hsh[k] = v
			else
				@hsh[k] = v.name
			end
		}
		payload << @hsh
		
	}
#	p gen.count
}

payload.each{|l|
	Lineup.create!(l)
}

#		
#		lineups.each{|l|
#			payload << l
#		}

#		payload.uniq.each{|lineup|
#			Lineup.create!(lineup)
#		}
=begin
=end

=begin
puts "======= DISPLAY GENERATION ======"
generations.each{|g|
	#p g
	p g.class
	p g.count
	p g.uniq.count
	puts "\n\n\n\n\n\n\n\n\n\n\n"
}
puts generations.class
puts generations.count
puts "======= END DISPLAY GENERATION ======"
=end





	puts "============ END SCHEDULER ============"
	end # mega if 
end #scheduler
















