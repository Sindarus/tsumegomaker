class IaRandom

  def initialize(color)
    @color = color
  end

  def get_color
    @color
  end

  def play(board, legal_move, last_move)
    choose_from = []
    legal_move.each_index{|i|
      legal_move[i].each_index{|j|
        if legal_move[i][j]
          choose_from << [i,j]
        end
      }
    }
    if choose_from.empty?
      return [-1,-1]
    end
    prng = Random.new
    return choose_from[prng.rand choose_from.size]
  end

end
