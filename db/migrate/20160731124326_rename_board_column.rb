class RenameBoardColumn < ActiveRecord::Migration
  def change
    rename_column("problems", "yaml_initial_board", "yaml_initial_physical_board")
  end
end
