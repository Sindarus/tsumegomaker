require sgf
class Minimax
  def initialize(initial_board_text, height, width)
    @intial_board = Board.new(height, width)
    @board_width = width
    @board_height = height
    @ia_color = 2
    @player_color = 1
    @collection = SGF::Colection.new
    @first_node = SGF::Node.new(:parent => @collection.current_node)
  end

  def minimax(node, board, color)
    if final_node(node)
      return count_score(board)
    end
    create_children(node, board, color)
    if color == @ia_color
      max = 0
      max_node = nil
      node.children.each do |node_children|
        if (t = minimax(node_children, board, @player_color)) > max
          max = t
          max_node = node_children
        end
      end
      node.children.each do |node_children|
        if node_children != max_node
          node_children.remove_parent
        end
      end
      return max
    else
      min = @board_width * @board_height
      node.children.each do |node_children|
        if (t = minimax(node_children, board, @ia_color)) < min
          min = t
        end
      end
      return min
    end
  end
