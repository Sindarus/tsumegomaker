class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.integer :player_color
      t.integer :ia_color
      t.integer :height
      t.integer :width
      t.text :yaml_initial_board
      t.string :problem_file

      t.timestamps null: false
    end
  end
end
