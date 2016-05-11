class CreateGameStates < ActiveRecord::Migration
  def change
    create_table :game_states do |t|
      t.text :board_history
      t.text :move_history

      t.timestamps null: false
    end
  end
end
