load("board.rb")

b = Board.new(4,4,[true,false,false,false])
b.load_board("0000\n1111\n2222\n0000")
b.display
puts b.get_score
