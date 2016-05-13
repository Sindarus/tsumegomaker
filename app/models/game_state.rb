class GameState < ActiveRecord::Base

  def setup(problem_id)
    problem = Problem.find_by(id: problem_id)
    @player_color = problem.player_color
    @ia_color = problem.ia_color
    @board_history = problem.initial_board
    @move_history = ""
    @width = problem.width
    @height = problem.height
    @problem_id = problem_id
    save
  end

end
