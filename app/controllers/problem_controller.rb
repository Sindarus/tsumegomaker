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
    board_json = JSON::load params[:board]
    board = Board.new(board_json["height"],
                      board_json["width"],
                      board_json["not_border"])
    board.load_board_of_stone(board_json["board_of_stone"])
    problem.yaml_initial_board = YAML.dump board
    problem.height = board_json["height"]
    problem.width = board_json["width"]
    problem.player_color = 1 #TODO: Permit to the submitter to choose color
    problem.ia_color = 2
    problem.problem_file = "app/assets/problems/problem"+problem.id.to_s+".sgf"
    puts "STARTING MINIMAX. THIS MIGHT TAKE A WHILE."
    m = Minimax.new(board, 10) #TODO: Permit to the submitter to choose that
    m.launch_minimax
    m.save_sgf(File.open(problem.problem_file, "w"))
    problem.save
    render plain: "OK"
  end

end
