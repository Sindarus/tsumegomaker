load('minimax.rb')
load('board.rb')

b = Board.new(2,3)
b.load_board("111\n000")
m = Minimax.new(b,9)
puts m.launch_minimax
