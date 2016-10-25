class CreatePlayerPools < ActiveRecord::Migration[5.0]
  def change
    create_table :player_pools do |t|
      t.integer :player_id
      t.string :name
      t.string :name_and_id
      t.string :position
      t.string :team
      t.string :salary
      t.string :game_info
      t.float :avg_dk_fppg

      t.timestamps
    end
  end
end
