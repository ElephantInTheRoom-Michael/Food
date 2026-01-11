# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_11_010137) do
  create_table "conversions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "ingredient_id"
    t.decimal "serving", precision: 6, scale: 2
    t.string "serving_variant"
    t.datetime "updated_at", null: false
    t.decimal "volume", precision: 6, scale: 2
    t.integer "volume_unit_id"
    t.string "volume_variant"
    t.decimal "weight", precision: 6, scale: 2
    t.integer "weight_unit_id"
    t.index ["ingredient_id"], name: "index_conversions_on_ingredient_id"
    t.index ["volume_unit_id"], name: "index_conversions_on_volume_unit_id"
    t.index ["weight_unit_id"], name: "index_conversions_on_weight_unit_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "volume_units", force: :cascade do |t|
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "weight_units", force: :cascade do |t|
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "conversions", "ingredients"
  add_foreign_key "conversions", "volume_units"
  add_foreign_key "conversions", "weight_units"
end
