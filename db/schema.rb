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

ActiveRecord::Schema[8.1].define(version: 2026_02_16_130752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "endpoints", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.string "name"
    t.text "response_body", default: "{\"ok\": true}"
    t.string "response_content_type", default: "application/json"
    t.integer "response_status_code", default: 200
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["token"], name: "index_endpoints_on_token", unique: true
    t.index ["user_id"], name: "index_endpoints_on_user_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "endpoint_id", null: false
    t.string "role", default: "viewer"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["endpoint_id"], name: "index_team_members_on_endpoint_id"
    t.index ["user_id"], name: "index_team_members_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "plan"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "webhook_requests", force: :cascade do |t|
    t.text "body"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.bigint "endpoint_id", null: false
    t.jsonb "headers"
    t.string "http_method"
    t.jsonb "query_params"
    t.string "source_ip"
    t.datetime "updated_at", null: false
    t.index ["endpoint_id"], name: "index_webhook_requests_on_endpoint_id"
  end

  add_foreign_key "endpoints", "users"
  add_foreign_key "team_members", "endpoints"
  add_foreign_key "team_members", "users"
  add_foreign_key "webhook_requests", "endpoints"
end
