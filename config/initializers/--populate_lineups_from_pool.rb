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
							   				   ##		
		## Set the number of lineups you want  ##
		   num_lineups = 20 				   ##
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
			if pp.player_id != nil
				players << Player.where(id: pp.player_id)[0]
			end
		}
		players.sort_by!{|p| -p.fps}.uniq!
=begin		
		players.each do |p|
			p p.name
		end	
=end		

=begin
############ END LINEUP SELECTION METHOD ############


vname = Struct.new(:player, :name, :weight, :value)
 
def dynamic_programming_knapsack(items, max_weight)
  num_items = items.size
  cost_matrix = Array.new(num_items){Array.new(max_weight+1, 0)}
 
  num_items.times do |i|
    (max_weight + 1).times do |j|
      if(items[i].weight > j)
        cost_matrix[i][j] = cost_matrix[i-1][j]
      else
        cost_matrix[i][j] = [cost_matrix[i-1][j], items[i].value + cost_matrix[i-1][j-items[i].weight]].max
      end
    end
  end
  used_items = get_used_items(items, cost_matrix)
  [get_list_of_used_items_names(items, used_items),                     # used items names
   items.zip(used_items).map{|item,used| item.weight*used}.inject(:+),  # total weight
   cost_matrix.last.last]                                               # total value
end
 
def get_used_items(items, cost_matrix)
  i = cost_matrix.size - 1
  currentCost = cost_matrix[0].size - 1
  marked = cost_matrix.map{0}
 
  while(i >= 0 && currentCost >= 0)
    if(i == 0 && cost_matrix[i][currentCost] > 0 ) || (cost_matrix[i][currentCost] != cost_matrix[i-1][currentCost])
      marked[i] = 1
      currentCost -= items[i].weight
    end
    i -= 1
  end
  marked
end
 
def get_list_of_used_items_names(items, used_items)
  items.zip(used_items).map{|item,used| item.name if used>0}.compact.join(', ')
end

items = []
players.each{|p|
	items << vname[p, p.name, p.salary, p.fps]
}

solution = dynamic_programming_knapsack(items, 50000)
p solution



############ END LINEUP SELECTION METHOD ############
=end

=begin
###### CREATE LINEUP ROWS ######
		payload = []
		lineups.each{|l|
			payload << l
		}

		payload.uniq.each{|lineup|
			Lineup.create!(lineup)
		}
=end

	puts "============ END SCHEDULER ============"
	end # mega if 

end #scheduler




