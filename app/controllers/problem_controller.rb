class ProblemController < ApplicationController

  def list
    problems = Problem.all
    @problem_list = []
    problems.each do |problem|
      game_history = GameHistory.find_by(:user => @current_user, :problem => problem)
      @problem_list << [problem, game_history]
    end
  end

end
