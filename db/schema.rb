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

ActiveRecord::Schema.define(version: 20170908164718) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "description"
  end

  create_table "desk_orders", force: :cascade do |t|
    t.integer "number"
    t.decimal "total"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "qrpoint_id"
    t.string "type_service"
    t.bigint "form_payment_id"
    t.index ["form_payment_id"], name: "index_desk_orders_on_form_payment_id"
    t.index ["qrpoint_id"], name: "index_desk_orders_on_qrpoint_id"
  end

  create_table "form_payments", force: :cascade do |t|
    t.string "type_payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "desk_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "qnt"
    t.decimal "val_unit"
    t.decimal "val_total"
    t.string "name_prod"
    t.string "status"
    t.index ["desk_order_id"], name: "index_items_on_desk_order_id"
    t.index ["product_id"], name: "index_items_on_product_id"
  end

  create_table "loginfos", force: :cascade do |t|
    t.string "employee"
    t.string "task"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string "doc_number"
    t.string "type_doc"
    t.bigint "supplier_id"
    t.string "description"
    t.date "due_date"
    t.date "payment_date"
    t.integer "installments"
    t.decimal "value_doc"
    t.string "form_payment"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_payments_on_supplier_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "qnt"
    t.decimal "value"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "description"
    t.boolean "check_stock"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "qrpoints", force: :cascade do |t|
    t.string "description"
    t.string "qrcode"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "receipts", force: :cascade do |t|
    t.string "doc_number"
    t.string "description"
    t.date "due_date"
    t.date "receipt_date"
    t.integer "installments"
    t.decimal "value_doc"
    t.string "form_receipt"
    t.integer "desk_order_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type_doc"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "cep"
    t.string "address"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "phone"
    t.string "cellphone"
    t.string "cnpj"
    t.string "email"
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

  add_foreign_key "desk_orders", "form_payments"
  add_foreign_key "desk_orders", "qrpoints"
  add_foreign_key "items", "desk_orders"
  add_foreign_key "items", "products"
  add_foreign_key "payments", "suppliers"
  add_foreign_key "products", "categories"
end
