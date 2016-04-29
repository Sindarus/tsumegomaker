load("game.rb")
load("board.rb")
load("playerconsole.rb")
load("iarandom.rb")

b = Board.new(9,9)
g = Game.new
p1 = PlayerConsole.new(1)
p2 = PlayerConsole.new(2)
p3 = IaRandom.new(2)

g.set_board(b)
g.set_player(p1)
g.set_player(p2)

g.launch_game
