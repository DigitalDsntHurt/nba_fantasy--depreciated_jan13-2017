class Player < ApplicationRecord

	validates :name, :position, :team, :basketball_reference_gamelog_url, presence: true
	validates :id, :basketball_reference_gamelog_url, uniqueness: true
	
end
