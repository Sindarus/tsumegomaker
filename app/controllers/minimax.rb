require 'sgf'
load("my_error.rb")
load("board.rb")
class Minimax
  def initialize(initial_board, nb_max_move)
    @initial_board = initial_board
    @nb_max_move = nb_max_move
    @ia_color = 2
    @player_color = 1
    @color_s = [nil, 'B', 'W']
    @collection = SGF::Collection.new
    @first_node = SGF::Node.new(:parent => @collection.current_node) 
  end

  def launch_minimax
    max_score, win_nodes = minimax(@first_node, @initial_board, @ia_color)
    add_win_msg(win_nodes)
  end

  def add_win_msg(nodes)
    nodes.each do |node|
      node['N'] = "M20"
    end
  end

  def show_tree
    show_tree_aux(@first_node, @initial_board, @ia_color)
  end

  def show_tree_aux(node, prev_board, color)
    board = prev_board.clone
    if node.depth != 1
      i,j = extract_move(node,color)
      board.add_stone(i,j,color)
    end
    node.depth.times do print " " end
    puts "Profondeur #{node.depth}"
    node.depth.times do print " " end
    puts "Coup " + (color == 1 ? "X" : "O") + " : #{i}, #{j}"
    if node["N"] == "M20"
      node.depth.times do print " " end
      puts "WIN"
    elsif node.children.empty?
      node.depth.times do print " " end
      puts "LOSE"
    end
    board.display
    sleep 2
    node.children.each do |child_node|
      show_tree_aux(child_node, board, (color == 1 ? 2 : 1))
    end
  end

  def minimax(node, prev_board, prev_color)
    board = prev_board.clone
    if node.depth != 1
      i,j = extract_move(node,prev_color)
      board.add_stone(i,j,prev_color)
    end
    if final_node(node)
      s = count_score(board)
      puts s,"\n"
      return s,[node]
    end
    final_nodes = []
    if color == @player_color
      create_children(node, board, @ia_color)
      max = -9999999
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
      min = 9999999
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
      legal_board[i].each_index do |j|
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
    return (((node["B"] == "" or node["W"] == "" ) and
             (node.parent["B"] == "" or node.parent["W"] == "")) or
           (node.depth >= @nb_max_move))
  end

  def count_score(board)
    scores = board.get_score()
    return scores[0]-scores[1]
  end
end
