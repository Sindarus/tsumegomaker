class GamesStateController < ApplicationController

  def initialize
    @board = nil
    @move_history = []
    @ia_player = nil
  end

  def load_state(game_state_id)
    @game_state = GameState.find_by(id: game_state_id)
    problem_file = Problem.find_by(id: @game_state.problem_id).problem_file
    @ia_player = IaSgf.new(@game_state.ia_color, problem_file)
    load_move_history
    @ia_player.catch_up(@move_history)
    @board = Board.new(@game_state.height, @game_state.width)
    @board.load_board(@game_state.board_history.split[0..@game_state.height-1].join)
  end

  def load_move_history
    @game_state.move_history.each_line{|move|
      @move_history << move.split
    }
    @move_history.reverse!
  end

  def save_move_history
    move_history_text = ""
    @move_history.reverse!
    @move_history.each{|i,j|
      move_history_text << i.to_str + " " + j.to_str + "\n"
    }
  end

  def player_move(i,j)
    if [i,j] == [-1,-1]
     @move_history = [[i,j]] + @move_history
     return
    end
    if ! @board.is_legal?(i,j,@game_state.player_color)
      raise "This move is illegal"
    end
    @move_history = [[i,j]] + @move_history
    @board.add_stone(i, j, @game_state.player_color)
  end

  def save_state(game_state_id)
    board_history = @board.to_text + @game_state.board_history
    @game_state.board_history = board_history
    save_move_history
  end

  def send_board
    @content = @board.to_text
  end

  def send_id
    @content = @game_state.id
  end

  def move
    game_state_id = params[:id]
    i = params[:i]
    j = params[:j]
    load_state(game_state_id)
    player_move(i, j)
    ia_move = @ia_player.play(@board.get_board,
                    @board.get_legal(@ia_player.get_color), [i,j])
    @move_history = [ia_move] + @move_history
    save_state(game_state_id)
    send_board
  end

  def get_board
    game_state_id = params[:id]
    load_state(game_state_id)
    send_board
  end

  def create_game
    problem_id = params[:problem_id]
    @game_state = GameState.new
    @game_state.setup(problem_id)
    @game_state.save
    send_id
  end

end
