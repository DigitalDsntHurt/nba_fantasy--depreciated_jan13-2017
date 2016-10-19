class PlayerGamesController < ApplicationController
  def index
  	@player_games = PlayerGame.all
  end
end
