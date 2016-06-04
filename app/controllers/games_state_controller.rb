class GamesStateController < ApplicationController

  def initialize
    @board = nil
    @move_history = []
    @ia_player = nil
  end

  def load_state(game_state_id)
    @game_state = GameState.find_by(id: game_state_id)
    @problem = Problem.find_by(id: @game_state.problem_id)
    problem_file = @problem.problem_file
    begin
      @ia_player = IaSgf.new(@problem.ia_color, problem_file)
    rescue MyError::IaInitError
      send_code("E00")
      return
    end
    load_move_history
    begin
      @ia_player.catch_up(@move_history)
    rescue MyError::MoveError
      send_code("E01")
      return
    end
    @board = Board.new(@game_state.height, @game_state.width)
    @board.load_board(@game_state.board_history.split[0..@game_state.height-1].join("\n"))
  end

  def send_code(string)
    render plain: string
  end

  def load_move_history
    @game_state.move_history.each_line{|move|
      @move_history << move.split
    }
    @move_history = @move_history.each.map{|move|
      move.each.map{|c|
        Integer(c)
      }
    }
    @move_history.reverse!
  end

  def save_move_history
    move_history_text = ""
    @move_history.reverse!
    @move_history.each{|i,j|
      move_history_text << i.to_s + " " + j.to_s + "\n"
    }
    @game_state.move_history = move_history_text
  end

  def add_move_history(i,j)
    @move_history << [i,j]
  end

  def player_move(i,j)
    if [i,j] == [-1,-1]
      add_move_history(i,j)
      return
    end
    if ! @board.is_legal?(i,j,@problem.player_color)
      send_code("E10")
      return
    end
    add_move_history(i,j)
    @board.add_stone(i, j, @problem.player_color)
  end

  def save_state(game_state_id)
    board_history = @board.to_text + @game_state.board_history
    @game_state.board_history = board_history
    save_move_history
    @game_state.save
  end

  def move
    if session[:game_state_id] == nil
        send_code("E03")
        return
    end
    load_state(session[:game_state_id])
    i = params[:i].to_i
    j = params[:j].to_i
    player_move(i, j)
    begin
      ia_move, ia_msg = @ia_player.play(@board.get_board,
                                   @board.get_legal(@ia_player.get_color),
                                   [i,j])
    rescue
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
    ia_i, ia_j = ia_move
    @board.add_stone(ia_i, ia_j, @problem.ia_color)
    add_move_history(ia_i,ia_j)
    save_state(session[:game_state_id])
    render plain: ia_msg
  end

  def get_board
    if session[:game_state_id] == nil
        send_code("E03")
        return
    end
    load_state(session[:game_state_id])
    render json: @board
  end

  def get_legal
    if session[:game_state_id] == nil
        send_code("E03")
        return
    end
    load_state(session[:game_state_id])
    render json: @board.get_legal(@problem.player_color)
  end

  def get_color
    if session[:game_state_id] == nil
        send_code("E03")
        return
    end
    load_state(session[:game_state_id])
    render plain: @problem.player_color.to_s
  end

  def create_game
    problem_id = params[:problem_id]
    @game_state = GameState.new
    @problem = Problem.find_by(id: problem_id)
    @game_state.board_history = @problem.initial_board
    @game_state.move_history = ""
    @game_state.width = @problem.width
    @game_state.height = @problem.height
    @game_state.problem_id = problem_id
    @game_state.save
    session[:game_state_id] = @game_state.id
    render nothing: true
  end

end
