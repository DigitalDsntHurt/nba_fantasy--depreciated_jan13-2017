# create arr of eligible players
# populate top 100 lineups

=begin
if PlayerPool.all.count != 0
Rufus::Scheduler.new.every '30s', :first_in => '1s' do
	#if Time.now - PlayerPool.all.take(1)[0].updated_at < 30 
		
		expected_updated = Time.now
		number_of_lineups = 5

		eligible_players = []
		Player.all.each{|player|
			PlayerPool.all.each{|playerp|	
				if player.name == playerp.name and player.team = playerp.team and player.position = playerp.position
					eligible_players << player
				end 
			}
		}
		eligible_players.sort_by!{ |p| -p.fps }

		lineups = []
		number_of_lineups.times do 
			@hsh = {}
			
			first_pg = eligible_players.index{|p| p.position.include?("PG") }
			p first_pg
#			@hsh[:pg] = eligible_players[first_pg]
			eligible_players.delete(eligible_players[first_pg])

			first_sg = eligible_players.index{|p| p.position.include?("SG") }
			p first_sg
#			@hsh[:sg] = eligible_players[first_sg]
			eligible_players.delete(eligible_players[first_sg])

			first_sf = eligible_players.index{|p| p.position.include?("SF") }
			p first_sf
#			@hsh[:sf] = eligible_players[first_sf]
			eligible_players.delete(eligible_players[first_sf])

			first_pf = eligible_players.index{|p| p.position.include?("PF") }
			p first_pf
#			@hsh[:pf] = eligible_players[first_pf]
			eligible_players.delete(eligible_players[first_pf])

			first_c = eligible_players.index{|p| p.position.include?("C") }
			p first_c
#			@hsh[:c] = eligible_players[first_c]
			eligible_players.delete(eligible_players[first_c])

			first_g = eligible_players.index{|p| p.position.include?("G") }
			p first_g
#			@hsh[:g] = eligible_players[first_g]
			eligible_players.delete(eligible_players[first_g])

			first_f = eligible_players.index{|p| p.position.include?("F") }
			p first_f
#			@hsh[:f] = eligible_players[first_f]
			eligible_players.delete(eligible_players[first_f])
			
			@hsh[:util] = eligible_players.first
			eligible_players.delete(eligible_players.first)

			lineups << @hsh
		end

		lineups.each{|hsh|
			Lineup.create!(
				:pg => "#{hsh[:pg].name}, #{hsh[:pg].fps}",
				:sg => "#{hsh[:sg].name}, #{hsh[:sg].fps}",	
				:sf => "#{hsh[:sf].name}, #{hsh[:sf].fps}",
				:pf => "#{hsh[:pf].name}, #{hsh[:pf].fps}",
				:c => "#{hsh[:c].name}, #{hsh[:c].fps}",
				:g =>"#{hsh[:g].name}, #{hsh[:g].fps}",
				:f => "#{hsh[:f].name}, #{hsh[:f].fps}",
				:util => "#{hsh[:util].name}, #{hsh[:util].fps}",
				:expected_fp => hsh[:pg].fps + hsh[:sg].fps + hsh[:sf].fps + hsh[:pf].fps + hsh[:c].fps + hsh[:g].fps + hsh[:f].fps + hsh[:util].fps,
				:expected_updated => expected_updated
			)
			puts "Lineup created!"
		}

	#end #time-based if 
end #scheduler
end #mega if

=end



