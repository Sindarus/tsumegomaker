# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160518231308) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_histories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "problem_id"
    t.boolean  "success"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "game_histories", ["problem_id"], name: "index_game_histories_on_problem_id", using: :btree
  add_index "game_histories", ["user_id"], name: "index_game_histories_on_user_id", using: :btree

  create_table "game_states", force: :cascade do |t|
    t.integer  "player_color"
    t.integer  "ia_color"
    t.text     "board_history"
    t.text     "move_history"
    t.integer  "width"
    t.integer  "height"
    t.integer  "problem_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "problems", force: :cascade do |t|
    t.integer  "player_color"
    t.integer  "ia_color"
    t.integer  "width"
    t.integer  "height"
    t.text     "initial_board"
    t.string   "problem_file"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
