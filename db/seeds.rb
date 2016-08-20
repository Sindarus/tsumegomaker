# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Problem.create(player_color: 1,
               ia_color: 2,
               width: 9, height: 9,
               yaml_initial_physical_board: "--- !ruby/object:PhysicalBoard\nwidth: 9\nheight: 9\nnot_border:\n- true\n- false\n- true\n- false\nboard_of_stone:\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 1\n  - 1\n  - 1\n  - 1\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 2\n  - 2\n  - 2\n  - 1\n  - 1\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 2\n  - 2\n  - 1\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 2\n  - 1\n  - 0\n  - 0\n  - 0\n  - 0\n",
               problem_file: "app/assets/problems/example1.sgf")
# Problem.create(player_color: 1,
#                ia_color: 2,
#                yaml_initial_board: "--- !ruby/object:Board\nboard: !ruby/object:PhysicalBoard\n  width: 5\n  height: 5\n  not_border:\n- true\n- false\n- true\n- false\n  board_of_stone:\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 2\n  - 2\n  - 2\n  - 2\n  - 2\n- - 1\n  - 1\n  - 1\n  - 1\n  - 2\n- - 0\n  - 0\n  - 0\n  - 1\n  - 2\nd4adj:\n- - 1\n  - 0\n- - -1\n  - 0\n- - 0\n  - 1\n- - 0\n  - -1\nko_move: []\nnb_captured:\n- 0\n- 0\nmove_history: []\nboard_history: []\n",
#                width: 5, height: 5,
#                problem_file: "app/assets/problems/example2.sgf")
# Problem.create(player_color: 1,
#                ia_color: 2,
#                yaml_initial_board: "--- !ruby/object:Board\nboard_of_stone:\n- - 0\n  - 0\n  - 1\n  - 2\n  - 2\n  - 0\n- - 0\n  - 0\n  - 0\n  - 1\n  - 2\n  - 0\n- - 0\n  - 1\n  - 1\n  - 1\n  - 2\n  - 0\n- - 0\n  - 2\n  - 2\n  - 2\n  - 2\n  - 0\n- - 0\n  - 2\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\nheight: 6\nwidth: 6\nd4adj:\n- - 1\n  - 0\n- - -1\n  - 0\n- - 0\n  - 1\n- - 0\n  - -1\nko_move: []\nnb_captured:\n- 0\n- 0\nnot_border:\n- false\n- false\n- true\n- true\nmove_history: []\nboard_history: []\n",
#                width: 6, height: 6,
#                problem_file: "app/assets/problems/example3.sgf")
# Problem.create(player_color: 1,
#                ia_color: 2,
#                yaml_initial_board: "--- !ruby/object:Board\nboard_of_stone:\n- - 0\n  - 2\n  - 0\n  - 0\n  - 0\n  - 1\n  - 0\n- - 2\n  - 2\n  - 0\n  - 2\n  - 2\n  - 1\n  - 0\n- - 0\n  - 1\n  - 0\n  - 2\n  - 1\n  - 1\n  - 0\n- - 0\n  - 1\n  - 1\n  - 1\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n- - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\n  - 0\nheight: 7\nwidth: 7\nd4adj:\n- - 1\n  - 0\n- - -1\n  - 0\n- - 0\n  - 1\n- - 0\n  - -1\nko_move: []\nnb_captured:\n- 0\n- 0\nnot_border:\n- false\n- false\n- true\n- true\nmove_history: []\nboard_history: []\n",
#                width: 7, height: 7,
#                problem_file: "app/assets/problems/example4.sgf")
