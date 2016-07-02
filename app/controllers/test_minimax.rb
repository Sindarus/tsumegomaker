load("board.rb")
load("minimax.rb")
b = Board.new(2,3,[false,false,false,false])
b.load_board("111\n000")
m = Minimax.new(b,8)
puts m.launch_minimax
m.show_tree

