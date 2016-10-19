class LineupsController < ApplicationController
  
  def index
  	@lineups = Lineup.all
  end
  
end
