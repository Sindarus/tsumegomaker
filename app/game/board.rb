class Board
  def initialize(height, width)
    @board_of_stone = Array.new(height) {Array.new(width){0}}
    @height = height
    @width = width
    @d4adj = [[1,0],[-1,0],[0,1],[0,-1]]
    @ko_move = []
  end
  def access_board(i, j)
    if 0 <= i and i < @height and
       0 <= j and j < @width
      return @board_of_stone[i][j]
    end
    return -1
  end
  def is_dead?(i,j)
    group, adj = get_adj(i,j)
    adj.each{|i,j|
      if access_board(i,j) == 0
        return false
      end
    }
    return true
  end
  def is_legal?(i,j,color)
    if access_board(i,j) != 0
      return false
    end
    if [i,j] == @ko_move # TODO : Check the color of the Ko move
      return false
    end
    @board_of_stone[i][j] = color
    if is_dead?(i,j)
       @d4adj.each{|di,dj|
         if access_board(i+di,j+dj) > 0 and
            access_board(i+di,j+dj)!= color
           if is_dead?(i+di,j+dj)
             @board_of_stone[i][j] = 0
             return true
           end
         end
       }
       @board_of_stone[i][j] = 0
       return false
    end
    @board_of_stone[i][j] = 0
    return true
  end
  def get_legal(color)
    Array.new(@height) {|i| Array.new(@width) {|j| is_legal?(i,j,color)}}
  end
  def kill_group(i,j)
    group, adj = get_adj(i,j)
    group.each{|i,j|
      @board_of_stone[i][j] = 0
    }
    return group
  end
  def get_adj(i,j)
    # Return two lists the first is the pos of the stones of the same "group"
    # The second is the pos of the stones adjacent to that "group"
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
  def add_stone(i, j, color)
    if access_board(i,j) != 0
      raise "This place (#{i},#{j}) is already taken !"
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
    @ko_move = []
    if captured.size == 1
      @ko_move = captured[0]
    end
    return @board_of_stone # TODO : Return the number of capured stone
  end
  def rm_stone(i,j)
    if access_board(i,j) == -1
      raise "This is not a valide position (#{i},#{j})"
    end
    @board_of_stone[i][j] = 0
 end
end
