class ProblemController < ApplicationController

  def list
    problems = Problem.all
    @problem_list = []
    problems.each do |problem|
      game_history = GameHistory.find_by(:user => @current_user, :problem => problem)
      @problem_list << [problem, game_history]
    end
  end

  def create

  end

  def submit
    problem = Problem.new
    new_id = Problem.last.id + 1 #This is a quick fix to find the new id.
    board_json = JSON::load params[:board]
    board = Board.new_from_scratch(height: board_json["height"],
                                   width: board_json["width"],
                                   not_border: board_json["not_border"])
    board.load_board_of_stone(board_json["board_of_stone"])
    problem.yaml_initial_board = YAML.dump board
    problem.height = board_json["height"]
    problem.width = board_json["width"]
    problem.player_color = params[:player_color]
    problem.ia_color = (problem.player_color == 1) ? 2 : 1
    problem.problem_file = "app/assets/problems/problem"+new_id.to_s+".sgf"
    puts "STARTING MINIMAX. THIS MIGHT TAKE A WHILE."
    m = Minimax.new(board, problem.player_color, 10)
    #TODO: Permit to the submitter to choose the number of move
    m.launch_minimax
    m.save_sgf(File.open(problem.problem_file, "w"))
    problem.save
    render plain: "OK"
  end

end
