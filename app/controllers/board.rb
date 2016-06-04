class Board
  # This class represents a board.
  # board_of_stone : a 2D array of integers. 0 means that the spot is empty,
  #                  1 means "black stone" and 2 means "white stone"
  # height
  # width
  # d4adj          : Constant used by some methods to make the code prettier.
  # ko_move        : when needed, this contains [[i, j], color], where (i, j) is
  #                  an illegal move for 'color' because of the simple ko rule.

  def initialize(height, width)
    @board_of_stone = Array.new(height) {Array.new(width){0}}
    @height = height
    @width = width
    @d4adj = [[1,0],[-1,0],[0,1],[0,-1]]
    @ko_move = []
  end

  def get_board
    @board_of_stone
  end

  def set_stone(i, j, stone)
    @board_of_stone[i][j] = stone
  end
  protected :set_stone

  def set_ko_move(ko_move)
    @ko_move = ko_move
  end
  protected :set_ko_move

  # returns the stone type at (i, j). If (i, j) is out of borders, returns -1.
  def access_board(i, j)
    if 0 <= i and i < @height and
       0 <= j and j < @width
      return @board_of_stone[i][j]
    end
    return -1
  end

  # loads into the instance a board described by the string "text_board"
  def load_board(text_board)
    i = 0
    text_board.each_line{|line|
      line.delete!("\n")
      j = 0
      line.each_char{|stone|
        @board_of_stone[i][j] = stone.to_i
        j += 1
      }
      i += 1
    }
  end

  # returns a copy (separate instance) of the current instance
  def get_copy
    board_copy = Board.new(@height, @width)
    board_copy.set_ko_move(@ko_move)

    i = 0
    @board_of_stone.each{|row|
        j = 0
      row.each{|stone|
        if(stone == 1 || stone == 2)
            board_copy.set_stone(i, j, stone)
        end
        j += 1
      }
      i += 1
    }
    return board_copy
  end

  # returns a string representing the board
  def to_text
    text = ""
    @board_of_stone.each{|row|
      row.each{|stone|
        text << stone.to_s
      }
      text << "\n"
    }
    return text
  end

  # Returns two lists. The first contains the position of every stone that
  # belong to the same "group" as the stone at (i, j).
  # The second contains the pos of the stones adjacent to that "group".
  def get_adj(i,j)
    same_group = [[i,j]]
    adj_group = []
    stone_file = [[i,j]]
    first_stone = access_board(i,j)
    while ! stone_file.empty?
      i, j = stone_file.pop
      @d4adj.each{|di,dj|
        current_stone = access_board(i+di,j+dj)
        current_pos = [i+di,j+dj]
        if current_stone == first_stone and
             ! same_group.include?(current_pos)
          stone_file << current_pos
          same_group << current_pos
        end
        if current_stone != first_stone and current_stone != -1
          adj_group << current_pos
        end
      }
    end
    return same_group, adj_group
  end

  # returns true if the stone or "group" at (i, j) has no 'liberty' and should
  # be removed from the board
  def is_dead?(i, j)
    group, adj = get_adj(i,j)
    adj.each{|i,j|
      if access_board(i,j) == 0
        return false
      end
    }
    return true
  end

  # returns true if the move (i, j) is legal for the player that plays 'color'
  def is_legal?(i,j,color)
    if access_board(i,j) != 0
      return false
    end
    if [[i,j],color] == @ko_move
      return false
    end
    @board_of_stone[i][j] = color     # put stone
    if is_dead?(i,j)                  # if the stone we just put is dead
      @d4adj.each{|di,dj|             # search if the stone allows to kill a group of another color
       if access_board(i+di,j+dj) > 0 and
          access_board(i+di,j+dj) != color
         if is_dead?(i+di,j+dj)       # if it does
           @board_of_stone[i][j] = 0
           return true
         end
       end
      }
      @board_of_stone[i][j] = 0       # if it does not
      return false
    end
    @board_of_stone[i][j] = 0         # if the stone we just put lives
    return true
  end

  #returns a 2D array of booleans that has the same shape as 'board_of_stones'.
  #All spots that have 'true' are legal to play for 'color'.
  def get_legal(color)
    if color == nil
      raise "get_legal : color provided is nil"
    end
    Array.new(@height){ |i|
      Array.new(@width){ |j|
        is_legal?(i,j,color)
      }
    }
  end

  # returns a string representing the 'get_legal' array.
  def get_legal_as_text(color)
    legal = get_legal(color)
    text = ""
    legal.each{|row|
      row.each{|stone|
        text << (stone.to_s == "true" ? "1" : "0")
      }
      text << "\n"
    }
    return text
  end

  # removes the "group" at (i, j) from the board.
  # Returns the list of coordinates where the removed stones were.
  def kill_group(i,j)
    group, adj = get_adj(i,j)
    group.each{|i,j|
      @board_of_stone[i][j] = 0
    }
    return group
  end

  # returns the color number of the opponent of 'color'.
  def opponent(color)
    if color <= 0
      raise "Nope, it's not a player, it's #{color}"
    end
    if color == 1
      return 2
    end
    if color == 2
      return 1
    end
    raise "What is that #{color} ?"
  end

  # makes 'color' play at (i, j) !
  # If (i, j) == (-1, -1), this is a "pass".
  def add_stone(i, j, color)
    if [i,j] == [-1,-1]
      return 0
    end
    if not is_legal?(i, j, color)
      raise "The move (#{i}, #{j}) is illegal for player #{color} !"
    end
    # Add the stone
    @board_of_stone[i][j] = color

    # Check if it kills an opponent
    captured = []
    @d4adj.each{|di,dj|
      if access_board(i+di,j+dj) > 0 and access_board(i+di,j+dj) != color
        if is_dead?(i+di,j+dj)
          captured += kill_group(i+di,j+dj)
        end
      end
    }

    # handle simple ko rule
    @ko_move = []
    if captured.size == 1         # if the move allowed to capture 1 stone
      group, adj = get_adj(i, j)
      if(group.size == 1)         # if the move does not form a "group"
        @ko_move = [captured[0],opponent(color)]
      end
    end
  end

  # displays the board in the console.
  def display
    @board_of_stone.each{|row|
      row.each{|stone|
        if stone == 0
          print(".")
        elsif stone == 1
          print("X")
        elsif stone == 2
          print("O")
        else
          raise "Stone type not supported for display."
        end
      }
      print("\n")
    }
  end

  # sets the spot (i, j) at '0'.
  def rm_stone(i,j)
    if access_board(i,j) == -1
      raise "This is not a valid position (#{i},#{j})"
    end
    @board_of_stone[i][j] = 0
  end

end
