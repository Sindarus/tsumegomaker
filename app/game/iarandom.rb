class iaRandom

  def initialize
  end

  def play(board, legal_move)
    choose_from = []
    legal_move.each_index{|i|
      legal_move[i].each_index{|j|
        if legal_move[i][j]
          choose_from << [i,j]
        end
      }
    }
    prng = Random.new
    return choose_from[prng.range choose_from.size]
  end

end