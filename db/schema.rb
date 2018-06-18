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

ActiveRecord::Schema.define(version: 20180618123319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "buy_items", force: :cascade do |t|
    t.integer  "buy_id"
    t.integer  "product_item_id"
    t.float    "price"
    t.float    "count"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "curr_count",      default: 0
  end

  create_table "buy_searches", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "title"
    t.integer  "product_item_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "buys", force: :cascade do |t|
    t.float    "price",       default: 0.0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "def_pay",     default: false
    t.integer  "provider_id"
    t.integer  "magazine_id"
    t.integer  "paid_out"
  end

  create_table "cachbox_items", force: :cascade do |t|
    t.string   "cachbox_item_table_type"
    t.integer  "cashbox_item_table_id"
    t.integer  "price"
    t.string   "type_cash"
    t.boolean  "type_mode"
    t.integer  "current_cash"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "cashboxes", force: :cascade do |t|
    t.integer  "cash"
    t.integer  "visa"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "magazine_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "title"
    t.text     "contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_prices", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "product_id"
    t.integer  "product_price_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "phone"
    t.string   "social"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.string   "barcode"
    t.integer  "purse",      default: 0
    t.integer  "cashback",   default: 2
    t.boolean  "opt",        default: false
    t.integer  "company_id"
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

  create_table "magazines", force: :cascade do |t|
    t.string   "title"
    t.string   "address"
    t.string   "phone"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "special_offer"
    t.string   "api_key"
    t.integer  "company_id"
    t.text     "vk_api_key_user"
    t.string   "vk_chat_id"
  end

  create_table "manager_payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "price"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "payment",     default: false
    t.integer  "magazine_id"
  end

  create_table "manager_shifts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.integer  "cash"
    t.integer  "visa"
    t.integer  "sum_sales"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.hstore   "items",      default: {},    null: false
    t.integer  "contact_id"
    t.text     "comment"
    t.integer  "company_id"
    t.boolean  "reserve",    default: false
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
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "type_mode",   default: true
    t.integer  "magazine_id"
    t.boolean  "processed",   default: true
  end

  create_table "product_item_counts", force: :cascade do |t|
    t.integer  "product_item_id"
    t.integer  "magazine_id"
    t.integer  "count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
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
    t.integer  "price_id"
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
    t.integer  "company_id"
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
    t.integer  "company_id"
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
    t.integer  "curr_count",       default: 0
    t.integer  "price_int",        default: 0
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.float    "price",       default: 0.0
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "profit",      default: 0
    t.boolean  "visa",        default: false
    t.integer  "magazine_id"
  end

  create_table "sms_phone_tasks", force: :cascade do |t|
    t.string   "phone"
    t.string   "body"
    t.boolean  "status",      default: false
    t.integer  "magazine_id"
    t.string   "sms_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "sms_phones", force: :cascade do |t|
    t.string   "address"
    t.text     "body"
    t.string   "date_time"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "id_sms"
    t.integer  "sum"
    t.boolean  "archive",     default: false
    t.integer  "magazine_id"
    t.text     "full_text"
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
    t.integer  "magazine_id"
    t.integer  "contact_id"
    t.string   "api_key"
    t.integer  "sum_shift",              default: 0
    t.string   "phone"
    t.boolean  "auto_payment",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vk_users", force: :cascade do |t|
    t.string   "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
