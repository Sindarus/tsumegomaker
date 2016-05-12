class CreateGameStates < ActiveRecord::Migration
  def change
    create_table :game_states do |t|
      t.integer :player_color
      t.integer :ia_color
      t.text :board_history
      t.text :move_history
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end
  end
end
