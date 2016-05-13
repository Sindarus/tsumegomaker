# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Problem.create(player_color: 1,
               ia_color: 2,
               initial_board: "00000\n11110\n22211\n00221\n00021\n",
               width: 5, height: 5,
               problem_file: "app/assets/problems/example.sgf")
