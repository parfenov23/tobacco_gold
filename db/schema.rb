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

ActiveRecord::Schema.define(version: 20160925102538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buy_items", force: :cascade do |t|
    t.integer  "buy_id"
    t.integer  "product_item_id"
    t.float    "price"
    t.float    "count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "buys", force: :cascade do |t|
    t.float    "price",      default: 0.0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "other_buys", force: :cascade do |t|
    t.string   "title"
    t.float    "price"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "type_mode",  default: true
  end

  create_table "product_items", force: :cascade do |t|
    t.string   "title"
    t.integer  "product_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "count",      default: 0
  end

  create_table "product_prices", force: :cascade do |t|
    t.float    "price",      default: 0.0
    t.integer  "product_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "title"
    t.boolean  "default",    default: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sale_items", force: :cascade do |t|
    t.integer  "sale_id"
    t.integer  "product_item_id"
    t.integer  "count",            default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "product_price_id"
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.float    "price",      default: 0.0
  end

end
