require 'sgf'
class IaSgf

  def initialize(color,sgf_file)
    @color = color
    @other_color = (@color == 1 ? 2 : 1)
    @collection = SGF::Parser.new.parse IO.read(sgf_file)
    if @collection.current_node.children.size != 1
      raise "There is several Gametrees in this file"
    end
    @current_node = @collection.current_node.children[0]
  end

  def get_color
    @color
  end

  def extract_move(node, color)
    if color == 1
      color_s = "B"
    else
      color_s = "W"
    end
    move_s = node[color_s]
    if move_s == nil
      raise "There is no move of the right color in this node."
    end
    if move_s == ""
      return [-1,-1]
    end
    j = move_s[0].ord - 97
    i = move_s[1].ord - 97
    return [i,j]
  end

  def go_to_move(move, color)
    ok = false
    @current_node.children.each{|node|
      if extract_move(node, color) == move
        @current_node = node
        ok = true
        break
      end
    }
    if not ok
      raise "The move #{move} is not registered in the sgf."
    end
  end

  def play(board, legal, last_move)
    if last_move != []
      go_to_move(last_move, @other_color)
    end
    if @current_node.children.size != 1
        raise "There is several way to respond"
    end
    @current_node = @current_node.children[0]
    return extract_move(@current_node, @color)
  end

  def catch_up(move_history)
    my_turn = false
    move_history.each{|move|
      go_to_move(move, (my_turn ? @color : @other_color))
      my_turn = (my_turn ? false : true)
    }
  end

end
