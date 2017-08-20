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

ActiveRecord::Schema.define(version: 20170819204518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "desk_orders", force: :cascade do |t|
    t.integer "number"
    t.decimal "total"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "form_payment"
    t.bigint "qrpoint_id"
    t.index ["qrpoint_id"], name: "index_desk_orders_on_qrpoint_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "desk_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "qnt"
    t.decimal "val_unit"
    t.decimal "val_total"
    t.index ["desk_order_id"], name: "index_items_on_desk_order_id"
    t.index ["product_id"], name: "index_items_on_product_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "qnt"
    t.decimal "value"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "qrpoints", force: :cascade do |t|
    t.string "description"
    t.string "qrcode"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "desk_orders", "qrpoints"
  add_foreign_key "items", "desk_orders"
  add_foreign_key "items", "products"
  add_foreign_key "products", "categories"
end
