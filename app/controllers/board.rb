class Board
  # This class represents a board.
  # board_of_stone : a 2D array of integers. 0 means that the spot is empty,
  #                  1 means "black stone" and 2 means "white stone"
  # height         :
  # width          :
  # d4adj          : Constant used by some methods to make the code prettier.
  # ko_move        : when needed, this contains [[i, j], color], where (i, j) is
  #                  an illegal move for 'color' because of the simple ko rule.
  # nb_captured    : [number of stones captured by black, by white].
  # not_border     : [true if border #0 is not a border, #1, #2, #3]
  #
  # border numbers
  #  _______
  # |   0   |
  # |       |
  # |1     2|
  # |       |
  # |___3___|
  # a border is called "not-border" to symbolize the fact that there is the rest
  # of the board behind it, i.e. empty spots.

  attr_reader :nb_captured  # creates a getter for nb_captured

  def initialize(height, width, not_border = [false, false, false, false])
    # checking parameter's integrity
    if(height <= 1 || width <= 1)
      raise "In Board.initialize() : Cannot create a board with size " + height.to_s + "x" + width.to_s + "."
    end
    if not_border.size != 4 then
      raise "In Board.initialize() : not_border should be size 4"
    end
    not_border.each do |value|
      if value != true and value != false then raise
        raise "In Board.initialize() : not_border invalid"
      end
    end

    @board_of_stone = Array.new(height) {Array.new(width){0}}
    @height = height
    @width = width
    @d4adj = [[1,0],[-1,0],[0,1],[0,-1]]
    @ko_move = []
    @nb_captured = [0, 0]
    @not_border = not_border
  end

  def get_board
    @board_of_stone
  end

  def set_ko_move(ko_move)
    @ko_move = ko_move
  end
  protected :set_ko_move

  # returns the stone type at (i, j). If (i, j) is out of borders, returns -1.
  # if (i, j) is out of not-borders by 2 squares, return -1 too. This is needed to
  # avoid get_adj to loop forever
  def access_board(i, j)
    ret_zero = false  # should we return 0 because (i, j) is out of bounds but not too far ?
    if i < 0
      if ! @not_border[0] || i < -1
        return -1
      end
      rret_zero = true
    end

    if i >= @height
      if ! @not_border[3] || i >= @height + 1
        return -1
      end
      ret_zero = true
    end

    if j < 0
      if ! @not_border[1] || j < -1
        return -1
      end
      ret_zero = true
    end

    if j >= @width
      if ! @not_border[2] || j >= @width + 1
        return -1
      end
      ret_zero = true
    end

    # we return zero after all the previous check because returning -1 has priority
    if ret_zero
      return 0
    end

    # at this point, we know that (i, j) is inside all borders,
    # i.e. @board_of_stone[i][j] is set
    return @board_of_stone[i][j]
  end

  def set_stone_at(i, j, color)
    if ! [0, 1, 2].include?(color)
      raise "In set_stone_at() : unvalid color color " + color.to_s
    end
    if i < 0
      if ! @not_border[0]
        raise "In set_stone_at() : this spot is out of the board upwards."
      end
      if color != 0
        raise "In set_stone_at() : this spot is behind a not-border upwards, you can only set it to 'empty spot'"
      end
      return # do nothing
    end

    if i >= @height
      if ! @not_border[3]
        raise "In set_stone_at() : this spot is out of the board downwards."
      end
      if color != 0
        raise "In set_stone_at() : this spot is behind a not-border downwards, you can only set it to 'empty spot'"
      end
      return # do nothing
    end

    if j < 0
      if ! @not_border[1]
        raise "In set_stone_at() : this spot is out of the board leftwards."
      end
      if color != 0
        raise "In set_stone_at() : this spot is behind a not-border leftwards, you can only set it to 'empty spot'"
      end
      return # do nothing
    end

    if j >= @width
      if ! @not_border[2]
        raise "In set_stone_at() : this spot is out of the board rightwards."
      end
      if color != 0
        raise "In set_stone_at() : this spot is behind a not-border rightwards, you can only set it to 'empty spot'"
      end
      return # do nothing
    end

    @board_of_stone[i][j] = color
  end
  protected :set_stone_at

  # loads into the instance a board described by the string "text_board"
  # TODO delete this -dangerous- method after we've changed the way we save
  # boards in gamestate. (dangerous because it does not check the size of the board)
  def load_board(text_board)
    i = 0
    text_board.each_line{|line|
      line.delete!("\n")
      j = 0
      line.each_char{|stone|
        set_stone_at(i, j, stone.to_i)
        j += 1
      }
      i += 1
    }
  end

  # returns a copy (separate instance) of the current instance
  def get_copy
    board_copy = Board.new(@height, @width, @not_border)
    board_copy.set_ko_move(@ko_move)

    i = 0
    @board_of_stone.each{|row|
        j = 0
      row.each{|stone|
        if(stone == 1 || stone == 2)
            board_copy.set_stone_at(i, j, stone)
        end
        j += 1
      }
      i += 1
    }
    return board_copy
  end

  # returns a string representing the board
  # TODO : delete this -unaccurate- method once possible. "unaccurate" because the
  # resulting string does not contain all info about the board
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
  # (i, j) can be empty, 'empty' is then considered as a color.
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
    if i<0 or i>=@height or j<0 or j>=@width
      return false    # spot is not inside the (not-)borders
    end
    if access_board(i,j) != 0
      return false    # spot is not free
    end
    if [[i,j],color] == @ko_move
      return false
    end
    set_stone_at(i, j, color)         # put stone
    if is_dead?(i,j)                  # if the stone we just put is dead
      @d4adj.each{|di,dj|             # search if the stone allows to kill a group of another color
        if access_board(i+di,j+dj) == opponent(color)
          if is_dead?(i+di,j+dj)      # if it does
            set_stone_at(i, j, 0)     # remove stone
            return true
          end
        end
      }
      set_stone_at(i, j, 0)           # if it does not
      return false
    end
    set_stone_at(i, j, 0)             # if the stone we just put lives
    return true
  end

  # returns a 2D array of booleans that has the same shape as 'board_of_stones'.
  # All spots that have 'true' are legal to play for 'color'.
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
      set_stone_at(i, j, 0)
    }
    return group
  end
  protected :kill_group

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
    if color != 1 and color != 2
      raise "In add_stone() : Not a color."
    end

    if [i,j] == [-1,-1]                     #player passes
      #add one captured stone to its opponent (AGA rules)
      add_captured_stones(1, opponent(color))
      return 0
    end

    if not is_legal?(i, j, color)
      raise "The move (#{i}, #{j}) is illegal for player #{color} !"
    end
    # Add the stone
    set_stone_at(i, j, color)

    # Check if it kills an opponent
    captured = []
    @d4adj.each{|di,dj|
      if access_board(i+di,j+dj) > 0 and access_board(i+di,j+dj) != color
        if is_dead?(i+di,j+dj)
          captured += kill_group(i+di,j+dj)
        end
      end
    }

    add_captured_stones(captured.size, color)

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
    #first line
    if @not_border[1]
      print("--")
    end
    if @not_border[0]
      @width.times do
        print("|")
      end
    end
    if @not_border[2]
      print("--")
    end
    print("\n")

    @board_of_stone.each{|row|
      if @not_border[1]
        print("--")
      end
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
      if @not_border[2]
        print("--")
      end
      print("\n")
    }

    #last line
    if @not_border[1]
      print("--")
    end
    if @not_border[3]
      @width.times do
        print("|")
      end
    end
    if @not_border[2]
      print("--")
    end
    print("\n")
    return nil
  end

  # sets the spot (i, j) at '0'.
  def rm_stone(i,j)
    if access_board(i,j) == -1
      raise "This is not a valid position (#{i},#{j})"
    end
    set_stone_at(i, j, 0)
  end
  protected :rm_stone

  # adds 'nb' captured stones to 'color'
  def add_captured_stones(nb, color)
    if nb < 0
      raise "In add_captured_stones() : cannot capture a negative amount of stones."
    end
    if color != 1 and color != 2
      raise "In add_captured_stones() : " + color.to_s + " is not a valid color."
    end
    @nb_captured[color - 1] += nb
    # -1 because black player is 1 and his captured stones are counted
    # by nb_captured[0]
  end
  protected :add_captured_stones

  # returns [score of black, score of white]
  def get_score
    empty_squares = []   # lists of empty squares we have already counted
    score = [0, 0]       # [score of black, score of white]

    #for each stone of the board
    @board_of_stone.each_with_index do |row, i|
      row.each_with_index do |stone, j|
        # if the spot is empty and we've not counted it yet
        if stone == 0 && !empty_squares.include?([i, j])
          # get the group of empty spots and its adjacents
          group, adj = get_adj(i, j)
          # the player who gets the points depend on the color of the adjacents
          cur_adj_color = group_color(adj)
          # if the group of adj is all black or all white
          if(cur_adj_color > 0)
            score[cur_adj_color-1] += group.size    # count score
            empty_squares += group                  # save empty spots that have been counted
          end
        end
      end
    end

    #add captured stones
    for i in [0, 1] do
      score[i] += nb_captured[i]
    end

    return score
  end

  # returns 0 if the group is a group of empty spots
  # returns 1 if the group is a group of black stones
  # returns 2 if the group is a group of white stones
  # returns -1 if the group is a mix of multiple color
  # returns -2 if no valid color was found
  #group should be [[i, j], [i, j], ...]
  def group_color(group)
    found = [0, 0, 0]   # found[0] = 1 if empty spot was found

    # for each pos in the group
    group.each do |i, j|
      cur_color = access_board(i, j)
      if cur_color != -1
        found[cur_color] = 1
        if found.reduce(:+) > 1      # if the sum of "found" > 1
          return -1                  # it means more than 1 color was found
        end
      end
    end

    #at this point, we know we haven't found more than 1 color
    if found.reduce(:+) == 0
      return -2
    end

    found.each_with_index do |was_found, color|
      if was_found == 1
        return color
      end
    end
  end

end
