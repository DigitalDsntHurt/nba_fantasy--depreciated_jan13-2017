class CreatePlayerGames < ActiveRecord::Migration[5.0]
  def change
    create_table :player_games do |t|
      t.integer :player_id
      t.string :name
      t.string :team
      t.string :game_date
      t.integer :game_season
      t.string :home_away
      t.string :opponent
      t.string :game_result
      t.boolean :started
      t.string :minutes_played
      t.float :fps
      t.integer :points
      t.integer :three_pt_shots_made
      t.integer :o_rebounds
      t.integer :d_rebounds
      t.integer :assists
      t.integer :steals
      t.integer :blocks
      t.integer :turn_overs
      t.boolean :double_double
      t.boolean :triple_double

      t.timestamps
    end
  end
end
