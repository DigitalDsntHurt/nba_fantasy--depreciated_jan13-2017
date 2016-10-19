class PlayerGame < ApplicationRecord

	validates :player_id, :points, :assists, :steals, :blocks, presence: true

	after_validation :calculate_bonuses
	after_validation :calculate_fps

	protected
	
	def calculate_bonuses
		bonus_check = [ self.points.to_s.length, self.assists.to_s.length, self.steals.to_s.length, self.blocks.to_s.length, (self.o_rebounds+self.d_rebounds).to_s.length ] 
		if bonus_check.reject{|num| num < 2 }.count >= 3
			self.triple_double = true
			self.double_double = true
		elsif bonus_check.reject{|num| num < 2 }.count == 2
			self.triple_double = false
			self.double_double = true
		else
			self.triple_double = false
			self.double_double = false
		end
	end

	def calculate_fps
		score = self.points + self.three_pt_shots_made*0.5 + (o_rebounds+d_rebounds)*1.25 + assists*1.5 + steals*2 + blocks*2 - turn_overs*0.5
		if self.triple_double == true
	     	self.fps = score + 3.0
		elsif self.double_double == true
	    	self.fps = score + 1.5
	    else
	    	self.fps = score
		end
	end

end

