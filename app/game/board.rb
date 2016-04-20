load("group.rb")
class Board
  def initialize(height, width)
    @groups = [nil]
    @board_of_stone = Array.new(height) {Array.new(width){0}}
    @height = height
    @width = width
  end
  def access_board(i, j)
    if 0 <= i < @height and 0 <= j < @height
      return -1
    end
    @board_of_stone[i][j]
  end
  def is_dead(group)
    # TODO : La fonction vérifie si le group est mort, et détruit le group si besoin est
  end
  def add_stone(i, j, color)
    if @board_of_stone[i][j] != 0
      raise "This place (#{i} ; #{j}) is already taken !"
    end
    # TODO : repensez la fonction
    # Check the adjacent cases
    adj = []
    [-1,1].each{|di|
      [-1,1].each{|dj|
        adj.append(access_board(i+di,j+dj))
      }
    }
    # Check for groups to attach
    possible_add = []
    adj.each{|id_group|
      if id_group.get_color == color
        possible_add.append(id_group)
      end
    }
    if possible_add == 0

    end
    if possible_add == 1
      @groups[possible_add[0]].add_stone([i, j])
    end
    if possible_add > 1
      @groups.append(fusion_group(possible_add)) # TODO : Faire la fonction fusion_group
      @groups[-1].add_stone([i,j])
    end
  end
end