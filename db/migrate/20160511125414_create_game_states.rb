class CreateGameStates < ActiveRecord::Migration
  def change
    create_table :game_states do |t|
      t.integer :problem_id
      t.text :board
      t.timestamps null: false
    end
  end
end
