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

ActiveRecord::Schema.define(version: 20170919133304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "buy_items", force: :cascade do |t|
    t.integer  "buy_id"
    t.integer  "product_item_id"
    t.float    "price"
    t.float    "count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "buys", force: :cascade do |t|
    t.float    "price",       default: 0.0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "def_pay",     default: false
    t.integer  "provider_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "phone"
    t.string   "social"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "content_pages", force: :cascade do |t|
    t.string   "name_page"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "history_vks", force: :cascade do |t|
    t.text     "params_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "hookah_cashes", force: :cascade do |t|
    t.string   "title"
    t.integer  "price",      default: 0
    t.boolean  "type_mode",  default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "manager_payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "price"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "payment",    default: false
  end

  create_table "mix_box_items", force: :cascade do |t|
    t.integer  "mix_box_id"
    t.string   "product_item_id"
    t.integer  "procent"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "mix_boxes", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "price"
    t.text     "img"
  end

  create_table "order_items", force: :cascade do |t|
    t.string   "title"
    t.integer  "sum",        default: 0
    t.integer  "order_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "order_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_phone"
    t.string   "status"
    t.text     "basket"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.hstore   "items",      default: {}, null: false
    t.integer  "contact_id"
    t.text     "comment"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "sum",        default: 0
    t.boolean  "pay",        default: false
    t.integer  "profit",     default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "contact_id"
    t.string   "hash_id"
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
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "count",       default: 0
    t.text     "description"
    t.string   "image_url"
    t.boolean  "in_stock",    default: false
    t.boolean  "top",         default: false
    t.string   "barcode"
  end

  create_table "product_prices", force: :cascade do |t|
    t.float    "price",      default: 0.0
    t.integer  "product_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "title"
    t.boolean  "default",    default: false
    t.boolean  "archive",    default: false
    t.boolean  "opt",        default: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "default_img"
    t.integer  "category_id"
  end

  create_table "provider_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "provider_id"
    t.integer  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text     "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "profit",     default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "login",                  default: "",     null: false
    t.text     "avatar"
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rate",                   default: 0
    t.boolean  "admin",                  default: false
    t.string   "role",                   default: "user"
    t.integer  "procent_sale",           default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vk_users", force: :cascade do |t|
    t.string   "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
