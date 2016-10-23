class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :position
      t.string :team
      t.float :fps
      t.integer :points
      t.integer :made_3pt_shots
      t.integer :rebounds
      t.integer :assists
      t.integer :steals
      t.integer :blocks
      t.integer :turnovers
      t.integer :salary
      t.string :basketball_reference_gamelog_url
      
      t.timestamps
    end
  end
end
