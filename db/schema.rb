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

ActiveRecord::Schema[7.0].define(version: 2023_06_13_000022) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "communities", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "country"
    t.string "city"
    t.boolean "is_public"
    t.boolean "is_visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "community_rsvps", force: :cascade do |t|
    t.integer "community_id"
    t.integer "user_id"
    t.string "status"
    t.bigint "users_id", null: false
    t.bigint "communities_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communities_id"], name: "index_community_rsvps_on_communities_id"
    t.index ["users_id"], name: "index_community_rsvps_on_users_id"
  end

  create_table "community_users", force: :cascade do |t|
    t.string "role"
    t.boolean "status"
    t.integer "id_users"
    t.integer "id_communities"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_rsvps", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.bigint "users_id", null: false
    t.bigint "events_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["events_id"], name: "index_event_rsvps_on_events_id"
    t.index ["users_id"], name: "index_event_rsvps_on_users_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.integer "start_date"
    t.integer "end_date"
    t.string "address"
    t.string "description"
    t.float "price"
    t.integer "capacity"
    t.integer "id_users"
    t.integer "id_communities"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string "type"
    t.integer "price"
    t.integer "user_id"
    t.integer "event_id"
    t.bigint "users_id", null: false
    t.bigint "events_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["events_id"], name: "index_tickets_on_events_id"
    t.index ["users_id"], name: "index_tickets_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "nationality"
    t.string "phone_number"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
    t.string "occupation"
    t.string "instagram_handle"
    t.boolean "is_admin", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "community_rsvps", "communities", column: "communities_id"
  add_foreign_key "community_rsvps", "users", column: "users_id"
  add_foreign_key "event_rsvps", "events", column: "events_id"
  add_foreign_key "event_rsvps", "users", column: "users_id"
  add_foreign_key "tickets", "events", column: "events_id"
  add_foreign_key "tickets", "users", column: "users_id"
end
