class PlayerConsole

  def initialize(color)
    @color = color
  end

  def get_color
    @color
  end

  def play(board, legal_moves, last_move)
    display board
    puts "Where do you want to play ?
Enter the line then the columnn or -1 -1 to pass"
    i = gets
    j = gets
    return [i.to_i,j.to_i]
  end
  
  def display(board)
    board.each{|row|
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

end
