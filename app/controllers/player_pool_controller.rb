class PlayerPoolController < ApplicationController
  
  def index
  	@player_pool = PlayerPool.all
  end

  def create
  	PlayerPool.new
  end

  def import
  		csv = PlayerPool.import(params[:file])
		redirect_to player_pool_path
  end

  def delete_pool
		PlayerPool.delete_all
		redirect_to player_pool_path
  end

end
