start = Time.now

require 'csv'

def get_stuff_from_page(page,xpath)
	begin
	  request = RestClient::Resource.new(page, :verify_ssl => false).get
	rescue RestClient::NotFound => not_found
	  return not_found
	rescue 
	  return nil
	else
	  	payload = []
	  	Nokogiri::HTML(request).xpath(xpath).map{|item|
			payload << item.text.strip if item != nil
		}
		return payload
	end
end

######################################
######################################
## => /////// HUMAN INPUT ////// <= ##
## 									##
# 									 #
	init_seed_players = true	     #
	seed_playergames = true			 #
	seed_players = true			 	 #
# 									 #
## 									##
## => ///// END HUMAN INPUT //// <= ##
######################################
######################################


##
#### Seed Players (two columns only) from csv
##
if init_seed_players == true


csv = CSV.open(Rails.root.join('lib', 'seeds', 'players.csv'))
csv.each{|row|
	Player.create!({ :name => row[0], :position => row[1], :team => row[2], :basketball_reference_gamelog_url => row[3] })
}
end



##
#### Seed PlayerGames from basketball-reference.com
##
if seed_playergames == true


players_query = Player.all
xpath = "//div[4]/div/div[2]/div/table/tbody/tr"
year = "2016"

players_query.each{|source_row|
	
	queries = []
	Nokogiri::HTML(open(source_row.basketball_reference_gamelog_url+year)).xpath(xpath).each_with_index{|row,i|
		queries << Nokogiri::HTML(row.to_html).xpath("//td/@data-stat | //td")
	}

	rows = []
	queries.each{|q|
		next if q.length == 0
		if q.length == 60
			first = 0
			second = 1
			@hsh = {}
			loop do 
				break if q[second].class == NilClass #or q[first].class == NilClass
				@hsh[q[second].text] = q[first].text
				first += 2
				second += 2
			end
			rows << @hsh
		end
	}

	player_import = []
	rows.uniq.each{|row|
		@hsh = {}
		@hsh["player_id"] = source_row.id
		@hsh["name"] = source_row.name
		@hsh["team"] = row["team_id"]
		@hsh["game_date"] = row["date_game"]#.to_datetime
		@hsh["game_season"] = row["game_season"].to_i
		if row["game_location"] == "@"
			@hsh["home_away"] = "away"
		else
			@hsh["home_away"] = "home"
		end
		@hsh["opponent"] = row["opp_id"]
		@hsh["game_result"] = row["game_result"]
		if row["gs"] == 1 
			@hsh["started"] = true
		else
			@hsh["started"] = false
		end
		@hsh["minutes_played"] = row["mp"]
		@hsh["points"] = row["pts"].to_i
		@hsh["three_pt_shots_made"] = row["fg3"].to_i
		@hsh["o_rebounds"] = row["orb"].to_i
		@hsh["d_rebounds"] = row["drb"].to_i
		@hsh["assists"] = row["ast"].to_i
		@hsh["steals"] = row["stl"].to_i
		@hsh["blocks"] = row["blk"].to_i
		@hsh["turn_overs"] = row["tov"].to_i
		
		player_import<< @hsh
	}

	if player_import.class == Array and player_import.count > 0
		player_import.uniq.each{|final_hsh|
			#PlayerGame.where(final_hsh).first_or_create!
			PlayerGame.create!(final_hsh)
		}
		puts "#{player_import.count} rows created for #{source_row.name}. Script has been running for #{(Time.now-start)/60} minutes."
	end
}
end




##
#### Seed Players from PlayerGames (after seeding PlayerGames)
##
if seed_players == true


Player.all.each{|player|
	query = PlayerGame.where(player_id: "#{player.id}").order(game_date: :desc).take(10)

	# points
	if query.pluck(:points).reject{|val| val == nil}.length == 0
		points = 0
	else
		points =  query.pluck(:points).reject{|val| val == nil}.inject{|sum, i| sum + i } / query.pluck(:points).reject{|val| val == nil}.length
	end

	# made 3pters
	if query.pluck(:three_pt_shots_made).reject{|val| val == nil}.length == 0
		three_pt_shots_made = 0
	else
		three_pt_shots_made =  query.pluck(:three_pt_shots_made).reject{|val| val == nil}.inject{|sum, i| sum + i } / query.pluck(:three_pt_shots_made).reject{|val| val == nil}.length
	end

	# rebounds
	if query.pluck(:o_rebounds).reject{|val| val == nil}.length +  query.pluck(:d_rebounds).reject{|val| val == nil}.length == 0
		rebounds = 0
	else
		rebounds = ( query.pluck(:o_rebounds).reject{|val| val == nil}.inject{|sum, i| sum + i } + query.pluck(:d_rebounds).reject{|val| val == nil}.inject{|sum, i| sum + i } ) / ( query.pluck(:o_rebounds).reject{|val| val == nil}.count + query.pluck(:d_rebounds).reject{|val| val == nil}.count )
	end

	# assists
	if query.pluck(:assists).reject{|val| val == nil}.length == 0
		assists = 0
	else
		assists =  query.pluck(:assists).reject{|val| val == nil}.inject{|sum, i| sum + i } / query.pluck(:assists).reject{|val| val == nil}.length
	end

	#steals
	if query.pluck(:steals).reject{|val| val == nil}.length == 0
		steals = 0
	else
		steals = query.pluck(:steals).reject{|val| val == nil}.inject{|sum, i| sum + i } / query.pluck(:steals).reject{|val| val == nil}.length
	end
	
	if query.pluck(:blocks).reject{|val| val == nil}.length == 0
		blocks = 0
	else
		blocks =  query.pluck(:blocks).reject{|val| val == nil}.inject{|sum, i| sum + i } / query.pluck(:blocks).reject{|val| val == nil}.length
	end

	# turnovers
	if query.pluck(:turn_overs).reject{|val| val == nil}.length == 0
		turn_overs = 0
	else
		turn_overs =  query.pluck(:turn_overs).reject{|val| val == nil}.inject{|sum, i| sum + i } / query.pluck(:turn_overs).reject{|val| val == nil}.length
	end
	
	# bonus + fps
	score = points + three_pt_shots_made*0.5 + rebounds*1.25 + assists*1.5 + steals*2 + blocks*2 - turn_overs*0.5
	bonus_check = [ points.to_s.length, assists.to_s.length, steals.to_s.length, blocks.to_s.length, rebounds.to_s.length ]
	if bonus_check.reject{|num| num < 2 }.count >= 3
     	fps = score + 3.0
	elsif bonus_check.reject{|num| num < 2 }.count == 2
    	fps = score + 1.5
    else
    	fps = score
	end 
	
	player.update(points: points, made_3pt_shots: three_pt_shots_made, rebounds: rebounds, assists: assists, steals: steals, blocks: blocks, turnovers: turn_overs , fps: fps ) #team: curent_team, 
	puts "Updated #{player.name}!"
}
end 


puts "*\n*\n*\nApp took #{(Time.now-start)/60} minutes to seed.\n*\n*\n*"