class CreateLineups < ActiveRecord::Migration[5.0]
  def change
    create_table :lineups do |t|
      t.string :pg
      t.string :sg
      t.string :sf
      t.string :pf
      t.string :c
      t.string :g
      t.string :f
      t.string :util
      t.float :expected_fp
      t.integer :salary
      t.string :expected_updated
      t.string :expected_method
      t.string :actual_fp
      t.string :actual_updated

      t.timestamps
    end
  end
end
