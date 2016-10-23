class AddSalaryToLineups < ActiveRecord::Migration[5.0]
  def change
  	add_column :lineups, :salary, :integer
  end
end
