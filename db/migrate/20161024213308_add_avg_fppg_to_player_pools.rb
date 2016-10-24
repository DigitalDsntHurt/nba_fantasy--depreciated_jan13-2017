class AddAvgFppgToPlayerPools < ActiveRecord::Migration[5.0]
  def change
	add_column :player_pools, :avg_fppg, :float
  end
end
