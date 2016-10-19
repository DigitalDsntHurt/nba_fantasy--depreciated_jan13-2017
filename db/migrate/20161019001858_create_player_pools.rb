class CreatePlayerPools < ActiveRecord::Migration[5.0]
  def change
    create_table :player_pools do |t|
      t.string :name
      t.string :name_and_id
      t.string :position
      t.string :team
      t.string :salary
      t.string :game_info

      t.timestamps
    end
  end
end