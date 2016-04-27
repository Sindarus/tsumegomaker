load('board.rb')
class Game
  def initialize
    @board = nil
    @players = [nil, nil]    # players[0] is the first to play (should be black)
    @history = []
    @turn = 0    # @turn is the number of board we have
  end

  def set_board(board)
    @board = board
    @history << @board.get_board
  end

  def set_player(player, number)
    @players[number] = player

  def launch_game
    if @board == nil
      raise "The board is not set"
    end
    if @players.include(nil)
      raise "One of the players is not set"
    end
    mainloop
  end

  def mainloop
    @players.each{|player|
      i,j = player.play(@board.get_board, @board.get_legal(@player.get_color))
      @board.add_stone(i,j,@player.get_color)
      @history << @board.get_board
      turn += 1
    }
  end

end
