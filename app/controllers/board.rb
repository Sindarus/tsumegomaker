require 'physical_board.rb'

class Board
  # This class represents a board.
  # board          : PhysicalBoard that holds the stones position
  # d4adj          : Constant used by some methods to make the code prettier.
  # ko_move        : when needed, this contains [[i, j], color], where (i, j) is
  #                  an illegal move for 'color' because of the simple ko rule.
  # nb_captured    : [number of stones captured by black, by white].
  # not_border     : [true if border #0 is not a border, #1, #2, #3]
  # move_history   : history of moves that were played. First moves are first in
  #                  the list. A move is described like : [i, j]
  # board_history  : history of boards. If stones are added on the
  #                  board without going through 'add_stone', the board won't be
  #                  saved, because the board only saves when one plays a legitimate
  #                  move, using 'add_stone()'.
  #
  # border numbers
  #  _______
  # |   0   |
  # |       |
  # |1     2|
  # |       |
  # |___3___|

  def initialize(height:, width:, not_border:)
    @board = PhysicalBoard.new(height: height, width: width, not_border: not_border)

    @d4adj = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    @ko_move = []
    @nb_captured = [0, 0]
    @move_history = []
    @board_history = []
  end

  def load_physical_board(physical_board)
    @board = physical_board
  end

  # returns the stone type at (i, j). If (i, j) is out of borders, returns -1.
  # if (i, j) is out of not-borders by 2 squares, return -1 too. This is needed to
  # avoid get_adj to loop forever
  def access_board(i, j, not_border_value=-1)
    return @board.get(i, j) == -1 ? not_border_value : @board.get(i, j)
  end

  # returns a copy (separate instance) of the current instance
  def clone
    # This is an easy fix to ruby's shameful lack of deep_copy.
    # Marshall.dump transforms any object in a string that can later be decoded to
    # yield the object back. This way, you get a deepcopy of the given object.
    # Easy but dirty.
    return Marshal.load( Marshal.dump(self) )
  end

  # Returns two lists. The first contains the position of every stone that
  # belong to the same "group" as the stone at (i, j).
  # The second contains the pos of the stones adjacent to that "group".
  # Empty spots behind not borders are included.
  # (i, j) parameter can be empty, 'empty' is then considered as a color.
  # However, if (i, j) is empty and belongs to the infinite empty group
  # (i.e. there's a path of empty spots from it to a not_border), then
  # this function returns [group, -1] where 'group' is the empty spots found
  # so far.
  def get_adj(i, j)
    same_group = [[i, j]]
    adj_group = []
    stone_queue = [[i, j]]
    first_stone = @board.get(i, j)
    while ! stone_queue.empty?
      i, j = stone_queue.pop
      @d4adj.each{|di, dj|
        current_stone = @board.get(i+di, j+dj)
        current_pos = [i+di, j+dj]
        if first_stone == 0 and @board.is_behind_not_border?(i+di, j+dj)
          return same_group, -1
        end
        if current_stone != -1
          if current_stone == first_stone
            if ! same_group.include?(current_pos)
              stone_queue << current_pos
              same_group << current_pos
            end
          else
            adj_group << current_pos
          end
        end
      }
    end
    return same_group, adj_group
  end

  # returns true if the stone or "group" at (i, j) has no "liberty" and should
  # be removed from the board
  def is_dead?(i, j)
    if @board.get(i, j) == 0
      raise "(#{i}, #{j}) is an empty spot. An empty spot cannot be said to be 'alive' or 'dead'"
    end

    group, adj = get_adj(i, j)
    adj.each{|i, j|
      if @board.get(i, j) == 0
        return false # because we just found a liberty
      end
    }
    return true
  end

  # returns true if the move (i, j) is legal for the player that plays 'color'
  def is_legal?(i, j, color)
    if i == -1 && j == -1
      return true     # passing is always legal
    end

    if @board.get(i, j) != 0
      return false    # spot is not free
    end

    if [[i, j], color] == @ko_move
      return false    # ko rule
    end

    @board.place(i, j, color)         # put temporary stone
    if is_dead?(i, j)                 # if the stone we just put is dead
      @d4adj.each{|di, dj|            # search if the stone allows to kill an enemy group
        if @board.get(i+di, j+dj) == opponent(color)
          if is_dead?(i+di, j+dj)     # if it allows to kill an enemy group
            @board.remove(i, j)       # remove temporary stone
            return true               # the move is legal
          end
        end
      }
      @board.remove(i, j)             # if the move doesn't allow to kill an enemy group
      return false
    end

    # if the stone we just put lives
    @board.remove(i, j)               # remove temporary stone

    return true
  end

  # returns a 2D array of booleans that has the same shape as 'board_of_stone'.
  # All spots that have 'true' as value are legal to play for 'color'.
  def get_legal(color)
    if color != 1 and color != 2
      raise "Cannot get legal moves of color #{color}"
    end
    Array.new(@board.height){ |i|
      Array.new(@board.width){ |j|
        is_legal?(i, j, color)
      }
    }
  end

  # removes the "group" at (i, j) from the board.
  # Returns the list of coordinates where the removed stones were.
  def remove_group(i, j)
    if @board.get(i, j) == 0
      raise "(#{i}, #{j}) is an empty spot. Cannot kill a group of empty stones"
    end

    group, adj = get_adj(i, j)
    group.each{|i, j|
      @board.remove(i, j)
    }
    return group
  end
  protected :remove_group

  # returns the color number of the opponent of 'color'.
  def opponent(color)
    if color != 1 and color != 2
      raise "Nope, it's not a player, it's #{color}"
    end
    if color == 1
      return 2
    end
    if color == 2
      return 1
    end
  end

  # makes 'color' play at (i, j) !
  # If (i, j) == (-1, -1), this is a "pass".
  def add_stone(i, j, color)
    if color != 1 and color != 2
      raise "Color '#{color}' is not a valid color."
    end
    if not is_legal?(i, j, color)
      raise "The move (#{i}, #{j}) is illegal for player #{color} !"
    end

    # save old board, and save move
    @board_history << b = Marshal.load(Marshal.dump(@board))
    @move_history << [i, j]

    if [i, j] == [-1, -1]                     # player passes
      #add one captured stone to its opponent (AGA rules)
      add_captured_stones(1, opponent(color))
      return
    end

    # Add the stone
    @board.place(i, j, color)

    # Check if it kills an opponent
    captured = []
    @d4adj.each{|di, dj|
      if @board.get(i+di, j+dj) == opponent(color)
        if is_dead?(i+di, j+dj)
          captured += remove_group(i+di, j+dj)
        end
      end
    }

    add_captured_stones(captured.size, color)

    # handle simple ko rule
    @ko_move = []
    if captured.size == 1         # if the move allowed to capture 1 stone
      group, adj = get_adj(i, j)
      if(group.size == 1)         # if the move does not form a "group"
        @ko_move = [captured[0], opponent(color)]
      end
    end
  end

  def display_board_history
    for board in board_history
      board.show()
      sleep(1)
    end
    return nil
  end

  # adds 'nb' captured stones to 'color'
  def add_captured_stones(nb, color)
    if nb < 0
      raise "Cannot capture a negative amount of stones."
    end
    if color != 1 and color != 2
      raise "Color '#{color}' is not a valid color."
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
    @board.board_of_stone.each_with_index do |row, i|
      row.each_with_index do |stone, j|
        # if the spot is empty and we've not counted it yet
        if stone == 0 && !empty_squares.include?([i, j])
          # get the group of empty spots and its adjacents
          group, adj = get_adj(i, j)
          # if get_adj returned -1, meaning (i, j) is linked to a not_border
          if adj == -1
            # no need to add it to empty_squares since we're not going to
            # check this specific spot again anyway.
            next    # jump to next iteration of each_with_index
          end
          # the player who gets the points depend on the color of the adjacents
          cur_adj_color = group_color(adj)
          # if the group of adj is all black or all white
          if(cur_adj_color > 0)
            # count score (cur_adj_color-1 because black's score is stored in score[0])
            score[cur_adj_color-1] += group.size
            # save empty spots that have been counted
            empty_squares += group
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
  # returns -2 if all stones in the group are behind borders
  # group should be [[i, j], [i, j], ...]
  # group does not have to be a "group" in the meaning of the go game (same color
  # stones that touch each other)
  def group_color(group)
    found = [0, 0, 0]   # found[0] = 1 if empty spot was found.
                        # We could've used booleans, but we needed
                        # found.reduce(:+) to easely know how much colors
                        # were found

    # for each pos in the group
    group.each do |i, j|
      cur_color = @board.get(i, j)
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

  # ATTRIBUTE READERS
  def board
    # Deep copy
    return Marshal.load( Marshal.dump(@board) )
  end

  def ko_move
    return Marshal.load( Marshal.dump(@ko_move) )
  end

  def nb_captured
    return Marshal.load( Marshal.dump(@nb_captured) )
  end

  def move_history
    return Marshal.load( Marshal.dump(@move_history) )
  end

  def board_history
    return Marshal.load( Marshal.dump(@board_history) )
  end

  # extra attribute reader
  # returns the 2D array containing the bulk of the board
  def get_board
    return Marshal.load( Marshal.dump(@board.board_of_stone) )
  end

end
