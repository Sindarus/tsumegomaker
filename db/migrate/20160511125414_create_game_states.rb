class CreateGameStates < ActiveRecord::Migration
  def change
    create_table :game_states do |t|
      t.integer :player_color
      t.integer :ia_color
      t.text :yaml_board
      t.integer :problem_id

      t.timestamps null: false
    end
  end
end
