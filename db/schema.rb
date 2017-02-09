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

ActiveRecord::Schema.define(version: 20170209200432) do

  create_table "holdings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.string   "type_of_holding"
    t.float    "quantity"
    t.float    "price_at_purchase"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["stock_id"], name: "index_holdings_on_stock_id"
    t.index ["user_id"], name: "index_holdings_on_user_id"
  end

  create_table "player_tournaments", force: :cascade do |t|
    t.integer  "stock_id"
    t.integer  "tournament_id"
    t.text     "player_tournament_info"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["stock_id"], name: "index_player_tournaments_on_stock_id"
    t.index ["tournament_id"], name: "index_player_tournaments_on_tournament_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.text     "schedule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "year"
  end

  create_table "stocks", force: :cascade do |t|
    t.string   "name"
    t.float    "current_price"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "league"
    t.string   "symbol"
    t.float    "open_price"
    t.integer  "player_id"
    t.text     "player_info"
    t.text     "player_news"
    t.integer  "first"
    t.integer  "second"
    t.integer  "third"
    t.integer  "top_ten"
    t.integer  "made_cut"
    t.integer  "top_twenty_five"
  end

  create_table "stocks_tags", force: :cascade do |t|
    t.integer "stock_id"
    t.integer "tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_tags_on_stock_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.text     "tournament_info"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "index"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.float    "cash",            default: 25000.0
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
