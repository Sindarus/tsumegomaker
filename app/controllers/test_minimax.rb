load("board.rb")
load("minimax.rb")
b = Board.new(2,3,[false,false,false,false])
b.load_board("111\n000")
m = Minimax.new(b,8)
max_score, win_nodes =  m.launch_minimax
puts "Max score is : #{max_score}"
win_nodes.each do |wn|
  m.show_path_to wn
end
m.show_tree

