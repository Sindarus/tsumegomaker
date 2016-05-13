class AddColumnProblems < ActiveRecord::Migration
  def change
    change_table :problems do |t|
    t.integer :ia_color
    t.integer :player_color
    t.text :initial_board
    t.integer :width
    t.integer :height
    t.string :problem_file
    end
  end
end
