class DebugController < ApplicationController
  def index
  	@players = Player.all
  	@player_games = PlayerGame.all
  	@lineups = Lineup.all
  	@player_pools = PlayerPool.all
  end
end
