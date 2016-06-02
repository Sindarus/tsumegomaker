require 'sgf'
load("my_error.rb")
load("board.rb")
class Minimax
  def initialize(initial_board, height, width)
    @initial_board = initial_board
    @board_width = width
    @board_height = height
    @ia_color = 2
    @player_color = 1
    @color_s = [nil, 'B', 'W']
    @collection = SGF::Collection.new
    @first_node = SGF::Node.new(:parent => @collection.current_node) 
    @first_node[@color_s[@ia_color]] = ""
  end
  def launch_minimax
    minimax(@first_node, @initial_board, @ia_color)
  end

  def minimax(node, prev_board, color)
    board = prev_board.get_copy
    i,j = extract_move(node,color)
    board.add_stone(i,j,color)
    puts "Profondeur #{node.depth}\nCoup " + (color == 1 ? "X" : "O") + " : #{i}, #{j}"
    board.display
    puts "\n"
    if final_node(node)
      return count_score(board),[node]
    end
    final_nodes = []
    if color == @player_color
      create_children(node, board, @ia_color)
      max = -1
      node.children.each do |node_children|
        t,f = minimax(node_children, board, @ia_color)
        if t > max
          max = t
          final_nodes = f
        elsif t == max
          final_nodes += f
        end
      end
      return max,final_nodes
    else
      create_children(node, board, @player_color)
      min = @board_width * @board_height
      min_node = nil
      node.children.each do |node_children|
        t,f = minimax(node_children, board, @player_color)
        if t < min
          min = t
          min_node = node_children
          final_nodes = f
        elsif t == min
          final_nodes += f
        end
      end
      node.children.each do |node_children|
        if node_children != min_node
          node_children.remove_parent
        end
      end
      return min,final_nodes
    end
  end

  def create_children(node, board, color)
    color_s = @color_s[color]
    n = SGF::Node.new(:parent => node)
    n[color_s] = ""
    legal_board = board.get_legal(color)
    legal_board.each_index do |i|
      legal_board.each_index do |j|
        if legal_board[i][j]
          n =SGF::Node.new(:parent => node)
          n[color_s] = move_to_s(i,j)
        end
      end
    end
  end

  def move_to_s(i,j)
    return (j+97).chr + (i+97).chr
  end

  def extract_move(node, color)
    color_s = @color_s[color]
    move_s = node[color_s]
    if move_s == nil
      raise MyError::ColorError.new "There is no move of the right color in this node."
    end
    if move_s == ""
      return [-1,-1]
    end
    j = move_s[0].ord - 97
    i = move_s[1].ord - 97
    return [i,j]
  end

  def final_node(node)
    return ((node["B"] == "" or node["W"] == "" ) and
           (node.parent["B"] == "" or node.parent["W"] == ""))
  end

  def count_score(node)
    return 0
  end
end
