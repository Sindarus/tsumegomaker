load('minimax.rb')
load('board.rb')

b = Board.new(4,5)
b.load_board("11110
22211
00221
00021")
m = Minimax.new(b,4,5)
m.launch_minimax
