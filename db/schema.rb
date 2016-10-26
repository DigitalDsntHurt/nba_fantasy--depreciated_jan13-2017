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

ActiveRecord::Schema.define(version: 20161019001858) do

  create_table "lineups", force: :cascade do |t|
    t.string   "pg"
    t.string   "sg"
    t.string   "sf"
    t.string   "pf"
    t.string   "c"
    t.string   "g"
    t.string   "f"
    t.string   "util"
    t.float    "expected_fp"
    t.integer  "salary"
    t.string   "expected_updated"
    t.string   "expected_method"
    t.string   "actual_fp"
    t.string   "actual_updated"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "player_games", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "name"
    t.string   "team"
    t.string   "game_date"
    t.integer  "game_season"
    t.string   "home_away"
    t.string   "opponent"
    t.string   "game_result"
    t.boolean  "started"
    t.string   "minutes_played"
    t.float    "fps"
    t.integer  "points"
    t.integer  "three_pt_shots_made"
    t.integer  "o_rebounds"
    t.integer  "d_rebounds"
    t.integer  "assists"
    t.integer  "steals"
    t.integer  "blocks"
    t.integer  "turn_overs"
    t.boolean  "double_double"
    t.boolean  "triple_double"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "player_pools", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "name"
    t.string   "name_and_id"
    t.string   "position"
    t.string   "team"
    t.string   "salary"
    t.string   "game_info"
    t.float    "avg_dk_fppg"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "position"
    t.string   "team"
    t.float    "fps"
    t.integer  "points"
    t.integer  "made_3pt_shots"
    t.integer  "rebounds"
    t.integer  "assists"
    t.integer  "steals"
    t.integer  "blocks"
    t.integer  "turnovers"
    t.integer  "salary"
    t.string   "basketball_reference_gamelog_url"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

end
