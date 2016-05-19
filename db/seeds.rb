# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Problem.create(player_color: 1,
               ia_color: 2,
               initial_board: "000000000\n000000000\n000000000\n000000000\n000000000\n111100000\n222110000\n002210000\n000210000\n",
               width: 9, height: 9,
               problem_file: "app/assets/problems/example1.sgf")
Problem.create(player_color: 1,
               ia_color: 2,
               initial_board: "02220\n22222\n22222\n11112\n00012\n",
               width: 5, height: 5,
               problem_file: "app/assets/problems/example2.sgf")
Problem.create(player_color: 1,
               ia_color: 2,
               initial_board: "001220\n000120\n011120\n022220\n020000\n000000",
               width: 6, height: 6,
               problem_file: "app/assets/problems/example3.sgf")