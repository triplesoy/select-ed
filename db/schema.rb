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

ActiveRecord::Schema[7.0].define(version: 2023_06_13_180112) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "communities", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "country"
    t.string "city"
    t.boolean "is_public"
    t.boolean "is_visible"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["user_id"], name: "index_communities_on_user_id"
  end

  create_table "community_join_requests", force: :cascade do |t|
    t.string "status"
    t.bigint "user_id", null: false
    t.bigint "community_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_join_requests_on_community_id"
    t.index ["user_id"], name: "index_community_join_requests_on_user_id"
  end

  create_table "community_users", force: :cascade do |t|
    t.string "role"
    t.boolean "status"
    t.bigint "user_id", null: false
    t.bigint "community_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_users_on_community_id"
    t.index ["user_id"], name: "index_community_users_on_user_id"
  end

  create_table "event_rsvps", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_rsvps_on_event_id"
    t.index ["user_id"], name: "index_event_rsvps_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "address"
    t.string "description"
    t.float "price"
    t.integer "capacity"
    t.bigint "user_id", null: false
    t.bigint "community_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_events_on_community_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "type"
    t.integer "price"
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_tickets_on_event_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
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

  add_foreign_key "communities", "users"
  add_foreign_key "community_join_requests", "communities"
  add_foreign_key "community_join_requests", "users"
  add_foreign_key "community_users", "communities"
  add_foreign_key "community_users", "users"
  add_foreign_key "event_rsvps", "events"
  add_foreign_key "event_rsvps", "users"
  add_foreign_key "events", "communities"
  add_foreign_key "events", "users"
  add_foreign_key "tickets", "events"
  add_foreign_key "tickets", "users"
end
