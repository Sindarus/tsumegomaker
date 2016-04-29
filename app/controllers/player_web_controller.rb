class PlayerWebController < ApplicationController

  def initialize(color)
    @color = color
    @move_ready = false
    @move = []
    @board = nil
    @move = []
  end

  def get_color
    @color
  end

  def get_board
    @board
  end

  def get_legal
    @legal
  end

  def move(i,j)
    @move = [i,j]
    @move_ready = true
  end

  def set_board(board)
    @board = ""
    board.each{|row|
      row.each{|stone|
        @board << stone.to_s
      }
      @board << "\n"
    }
  end

  def set_legal(legal)
    @legal = ""
    legal.each{|row|
      row.each{|stone|
        if stone
          @legal << "1"
        else
          @legal << "0"
        end
      }
      @legal << "\n"
    }
  end

  def play(board,legal_moves)
    set_board board
    set_legal legal_moves
    while ! @move_ready
      sleep
    end
    @move_ready = false
    return @move
  end
    
end
