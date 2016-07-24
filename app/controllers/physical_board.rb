require "constants.rb"

class PhysicalBoard
  # this class holds the stones and nothing else, there should be no logic here
  # only stones being added of removed.
  # As a good design, the methods here require accuracy and rigor :
  # for example, you cannot place a stone somewhere there is already one.

  # TERMINOLOGY
  # A border is one side of the go board boundaries.
  # A "not-border" is a side of the PhysicalBoard behind which there is the rest
  # of the board, i.e. empty spots.

  # The space behind a not-border is considered infinite. That's why 'get(i, j)'
  # will return 0 if (i, j) is behind a not border, however far it is.

  def initialize(width:, height:, not_border:)
    if not valid_not_border?(not_border)
      raise "Provided not_border is invalid. Possible causes are it is not size 4, or you are not using booleans"
    end

    size = (width)*(height)
    if(size < BOARD_MIN_SIZE)
      raise "A board cannot be smaller than #{BOARD_MIN_SIZE} squares. The one you are trying to create has #{size} squares with height: #{height} and width: #{width}."
    end
    if(size > BOARD_MAX_SIZE)
      raise "A board cannot be bigger than #{BOARD_MAX_SIZE} squares. The one you are trying to create has #{size} squares with height: #{height} and width: #{width}."
    end

    @width = width
    @height = height
    @not_border = not_border
    @board = Array.new(height) { Array.new(width){0} }
  end

  # place a stone at one spot if there is not one already
  def place(i, j, color)
    if not valid_color?(color)
      raise "The color #{color} is not a valid color to place."
    end

    if out_of_array?(i, j)
      raise "The spot (#{i}, #{j}) is out of array."
    end

    if @board[i][j] != 0
      raise "The spot (#{i}, #{j}) already has a stone of color #{@board[i][j]}."
    end

    @board[i][j] = color;
  end

  # removes a stone that was previously placed
  def remove(i, j)
    if out_of_array?(i, j)
      raise "The spot (#{i}, #{j}) is out of array."
    end

    if @board[i][j] == 0
      raise "The spot (#{i}, #{j}) has no stone to remove."
    end

    @board[i][j] = 0
  end

  # returns the color of a spot.
  # If the spot is outside the board, this returns -1.
  # If the spot is behind a not_border, this returns 0, because it is a free spot.
  def get(i, j)
    if not out_of_array?(i, j)
      # most common case: (i, j) is inside the @board array
      return @board[i][j]
    end

    if is_behind_border?(i, j)
      # other case: (i, j) is outside the go board
      return -1
    end

    # only case left is that (i, j) is behind a not_border
    return 0
  end

  # returns true if (i, j) is outside the go board
  def is_behind_border?(i, j)
    if ((i < 0 and not @not_border[0])         or
        (i >= @height and not @not_border[3])  or
        (j < 0 and not @not_border[1])         or
        (j >= @width and not @not_border[2]))
      return true
    end

    return false
  end

  # returns true if (i, j) is behind a not_border
  def is_behind_not_border?(i, j)
    if not out_of_array?(i, j) or is_behind_border?(i, j)
      return false
    end

    return true
  end

  # returns true if @board[i][j] is not defined. I.e. if (i, j) is outside
  # the inner_board (behind a not border or just non-existant, whatever)
  def out_of_array?(i, j)
    return (i < 0 or j < 0 or i >= @height or j >= @width)
  end

  def valid_color?(color)
    return (color == 1 or color == 2)
  end

  def valid_not_border?(not_border)
    if not_border.size != 4
      return false;
    end

    for i in 0..3
      if not [false, true].include?(not_border[i])
        return false;
      end
    end

    return true
  end

  # displays the physical board in console mode.
  def show(indent: 0)
    #first line
    if @not_border[1]
      print("--")
    else
      print("  ")
    end
    if @not_border[0]
      @width.times do
        print("|")
      end
    else
      @width.times do
        print(" ")
      end
    end
    if @not_border[2]
      print("--")
    end
    print("\n")

    @board.each{|row|
      indent.times do
        print " "
      end
      if @not_border[1]
        print("--")
      else
        print("  ")
      end
      row.each{|stone|
        if stone == 0
          print(".")
        elsif stone == 1
          print("X")
        elsif stone == 2
          print("O")
        else
          raise "Stone type not supported for display: #{stone}."
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
    else
      print("  ")
    end
    if @not_border[3]
      @width.times do
        print("|")
      end
    else
      @width.times do
        print(" ")
      end
    end
    if @not_border[2]
      print("--")
    else
      print("  ")
    end
    print("\n")
    return nil
  end

  # ATTRIBUTE READERS
  # 'width' and 'height' do not need specific attribute readers because they are
  # integers, which is a primitive type, and thus when you read 'width' from this
  # object, you cannot change the value of the instance's 'width' variable.
  # The arrays however, need to be copied before returned, so that by changing
  # the returned variable, you do not change the instance's variable.
  attr_reader :width
  attr_reader :height

  def not_border
    # Deep copy
    return Marshal.load( Marshal.dump(@not_border) )
  end

  def board
    # Deep copy
    return Marshal.load( Marshal.dump(@board) )
  end
end
