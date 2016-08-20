require 'board.rb'

class GamesStateController < ApplicationController
  # Properties:
  # rendered    : true if we have already rendered the response to the http get request
  # game_state_id : id of game_state object in DB. This id is kept on session.
  # game_state  : Object retrieved from DB that holds the state of the current game
  # ia_player   : IaSgf object un-yamled from game_state, that holds the current ia player

  def initialize
    # please set 'rendered' to true when you use "render". And when you "render",
    # check this variable, because if you use "render" twice in a single request
    # response cycle, it will cause a rails error.
    @rendered = false
  end

  # function that is called before we answer a client's request, using filter_before.
  # it retrieves user's gamestate_id from their session, or sends an error code
  # if the session has expired. Then, it retrieves the gamestate from the DB, and
  # re-create the ia_player object.
  # it returns true if there was no problem, false otherwise.
  def load_state()
    if session[:game_state_id] == nil
        send_code("E03")
        return false
    else
      @game_state_id = session[:game_state_id]
    end

    @game_state = GameState.find_by(id: @game_state_id)
    @problem = Problem.find_by(id: @game_state.problem_id)
    begin
      @ia_player = IaSgf.new(@problem.ia_color, @problem.problem_file)
    rescue MyError::IaInitError
      send_code("E00")
      return false
    end
    begin
      @ia_player.catch_up(@game_state.board.move_history)
    rescue MyError::IaError => e
      puts "ERREUR ==============================================="
      puts e.message
      puts e.backtrace
      puts "======================================================"
      send_code("E01")
      return false
    end
  end
  before_action :load_state, :only => [:move, :get_board, :get_legal, :get_color]

  def send_code(string)
    if not @rendered
      render plain: string
      @rendered = true
    end
  end

  def player_move(i, j)
    if [i,j] == [-1, -1]
      return
    end
    if ! @game_state.board.is_legal?(i, j, @problem.player_color)
      send_code("E10")
      return
    end
    @game_state.board.add_stone(i, j, @problem.player_color)
  end

  def save_state
    @game_state.save
  end

  def move
    i = params[:i].to_i
    j = params[:j].to_i
    player_move(i, j)
    begin
      ia_move, ia_msg = @ia_player.play(@game_state.board.get_board,
                                   @game_state.board.get_legal(@ia_player.get_color),
                                   [i,j])
    rescue MyError::IaError => e
      puts "ERREUR ==============================================="
      puts e.message
      puts e.backtrace
      puts "======================================================"
      send_code("E02")
      return
    end
    if ia_msg == "M20" or ia_msg == "M21"
      if @current_user
        game_history = GameHistory.find_or_create_by(:user => @current_user, :problem => @problem)
        if not game_history.success and ia_msg == "M21"
          game_history.success = false
        else
          game_history.success = true
        end
        game_history.save
      end
    end
    if ia_move != nil
      ia_i, ia_j = ia_move
      @game_state.board.add_stone(ia_i, ia_j, @problem.ia_color)
    end
    save_state
    if not @rendered
      render plain: ia_msg
      @rendered = true
    end
  end

  def get_board
    if not @rendered
      render json: @game_state.board.board
      # 1) game_state.board is the Board object
      # 2) game_state.board.board is the @board attribute of it, which is a
      # an object of type PhysicalBoard
      @rendered = true
    end
  end

  def get_legal
    if not @rendered
      render json: @game_state.board.get_legal(@problem.player_color)
      @rendered = true
    end
  end

  def get_color
    if not @rendered
      render plain: @problem.player_color.to_s
      @rendered = true
    end
  end

  def create_game
    # retrieve problem
    problem_id = params[:problem_id]
    @problem = Problem.find_by(id: problem_id)
    if @problem == nil
      session[:game_state_id] = nil
      send_code("E04")
      return
    end

    # create game_state
    @game_state = GameState.new
    @game_state.problem_id = problem_id
    physical_board = YAML.load(@problem.yaml_initial_physical_board)
    @game_state.board = Board.new(initial_physical_board: physical_board)
    save_state  # save gamestate in database

    # store game_state_id in session
    session[:game_state_id] = @game_state.id

    # respond to http request
    if not @rendered
      render nothing: true
      @rendered = true
    end
  end

end
