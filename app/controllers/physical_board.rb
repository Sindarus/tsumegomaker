require "constants.rb"

class PhysicalBoard
  # this class holds the stones and nothing else, there should be no logic here
  # only stones being added of removed.
  # As a good design, the methods here require accuracy and rigor :
  # for example, you cannot place a stone somewhere there is already one.

  def initialize(width:, height:, not_border: [false, false, false, false])
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

  # place a stone at one place if there is not one already
  def place(i, j, color)
    if not valid_color?(color)
      raise "The color #{color} is not a valid color to place."
    end

    if out_of_bounds?(i, j)
      raise "The spot (#{i}, #{j}) is out of bounds."
    end

    if @board[i][j] != 0
      raise "The spot (#{i}, #{j}) already has a stone of color #{@board[i][j]}."
    end

    @board[i][j] = color;
  end

  # removes a stone placed
  def remove(i, j)
    if out_of_bounds?(i, j)
      raise "The spot (#{i}, #{j}) is out of bounds."
    end

    if @board[i][j] == 0
      raise "The spot (#{i}, #{j}) has no stone to remove."
    end

    @board[i][j] = 0
  end

  # returns the color of a spot. If the spot is behind a not_border, this returns
  # 0, because it is a free spot. If the spot is outside the board, this returns -1.
  def get(i, j)
    if i < 0
      return ( @not_border[0] ? 0 : -1)
    end

    if i >= @height
      return ( @not_border[3] ? 0 : -1)
    end

    if j < 0
      return ( @not_border[1] ? 0 : -1)
    end

    if j >= @width
      return ( @not_border[2] ? 0 : -1)
    end

    # at this point, we know that (i, j) is inside all borders,
    # i.e. @board_of_stone[i][j] is set
    return @board[i][j]
  end

  def out_of_bounds?(i, j)
    return (i < 0 or j < 0 or i >= @height or j >= @width)
  end

  def valid_color?(color)
    return (color == 1 or color == 2)
  end

  # this displays the physical board in console mode.
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

end
