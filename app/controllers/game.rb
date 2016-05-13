class Game

  def initialize
    @board = nil
    @players = []    # players[0] is the first to play (should be black)
    @history = []
    @turn = 0    # @turn is the number of board we have
    @the_other_passed = false
    @continue = true
    @last_move = []
  end

  def set_board(board)
    @board = board
    @history << @board.get_board
  end

  def set_player(player)
    @players << player
  end

  def launch_game
    if @board == nil
      raise "The board is not set"
    end
    if @players.include?(nil)
      raise "One of the players is not set"
    end
    @continue = true
    while @continue
      mainloop
    end
  end

  def mainloop
    @players.each{|player|
      board = @board.get_board
      legal = @board.get_legal player.get_color
      i,j = player.play(board, legal, @last_move)
      if [i,j] == [-1,-1]
        if @the_other_passed
          @continue = false
          break
        end
        @the_other_passed = true
      else
        @the_other_passed = false
        if ! legal[i][j]
          raise "This move is invalid"
        end
        @board.add_stone(i,j,player.get_color)
      end
      @history << @board.get_board
      @last_move = [i,j]
      @turn += 1
    }
  end

end

