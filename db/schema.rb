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

ActiveRecord::Schema.define(version: 20170406140610) do

  create_table "golfer_tournaments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tournament_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "golfer_id"
    t.integer  "Rank"
    t.decimal  "TotalScore",    precision: 10
    t.decimal  "Earnings",      precision: 10
    t.index ["golfer_id"], name: "index_golfer_tournaments_on_golfer_id", using: :btree
    t.index ["tournament_id"], name: "index_golfer_tournaments_on_tournament_id", using: :btree
  end

  create_table "golfers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "first"
    t.integer  "second"
    t.integer  "third"
    t.integer  "top_ten"
    t.integer  "top_twenty_five"
    t.integer  "made_cut"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "stock_id"
    t.integer  "Weight"
    t.string   "Swings"
    t.integer  "PgaDebut"
    t.string   "Country"
    t.date     "BirthDate"
    t.string   "BirthCity"
    t.string   "BirthState"
    t.string   "College"
    t.index ["stock_id"], name: "index_golfers_on_stock_id", using: :btree
  end

  create_table "holdings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "stock_id"
    t.string   "type_of_holding"
    t.integer  "quantity"
    t.float    "price_at_purchase", limit: 24
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["stock_id"], name: "index_holdings_on_stock_id", using: :btree
    t.index ["user_id"], name: "index_holdings_on_user_id", using: :btree
  end

  create_table "news", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "stock_id"
    t.integer  "NewsID"
    t.integer  "PlayerID"
    t.text     "Title",      limit: 65535
    t.text     "Content",    limit: 65535
    t.text     "Url",        limit: 65535
    t.text     "Source",     limit: 65535
    t.text     "TermsOfUse", limit: 65535
    t.date     "Updated"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["stock_id"], name: "index_news_on_stock_id", using: :btree
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "content",    limit: 65535
    t.integer  "user_id"
    t.string   "tags"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "stocks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.float    "current_price",   limit: 24
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "symbol"
    t.float    "open_price",      limit: 24
    t.float    "high",            limit: 24
    t.float    "low",             limit: 24
    t.float    "season_high",     limit: 24
    t.float    "season_low",      limit: 24
    t.integer  "volume"
    t.integer  "earnings"
    t.text     "daily_prices",    limit: 65535
    t.string   "sport"
    t.float    "price_to_change", limit: 24
    t.float    "daily_change",    limit: 24,    default: 0.0
    t.integer  "num_trades",                    default: 0
    t.integer  "PlayerID"
    t.string   "PhotoUrl"
  end

  create_table "tournaments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "index"
    t.integer  "TournamentID"
    t.string   "Name"
    t.date     "StartDate"
    t.date     "EndDate"
    t.boolean  "IsOver"
    t.boolean  "IsInProgress"
    t.string   "Venue"
    t.string   "Location"
    t.integer  "Par"
    t.integer  "Yards"
    t.decimal  "Purse",        precision: 10
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "password_digest"
    t.boolean  "admin",                      default: false
    t.float    "cash",            limit: 24, default: 20000.0
    t.float    "account_value",   limit: 24, default: 20000.0
    t.float    "start_value",     limit: 24
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
