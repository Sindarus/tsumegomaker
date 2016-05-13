class AddColumnGameStates < ActiveRecord::Migration
  def change
    change_table :game_states do |t|
      t.integer :width
      t.integer :height
      t.integer :problem_id
    end
  end
end
