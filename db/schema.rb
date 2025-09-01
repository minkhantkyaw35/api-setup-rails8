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

ActiveRecord::Schema[8.0].define(version: 2025_09_01_161322) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti", unique: true
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.string "resource"
    t.string "action"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_analytics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "event_type"
    t.json "event_data"
    t.string "ip_address"
    t.text "user_agent"
    t.datetime "occurred_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_analytics_on_user_id"
  end

  create_table "user_devices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "device_name"
    t.string "device_type"
    t.string "device_identifier"
    t.datetime "last_login_at"
    t.string "ip_address"
    t.text "user_agent"
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_identifier"], name: "index_user_devices_on_device_identifier", unique: true
    t.index ["user_id"], name: "index_user_devices_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "user_settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "device_limit", default: 5, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.boolean "is_active", default: true, null: false
    t.datetime "last_login_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "user_analytics", "users"
  add_foreign_key "user_devices", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_settings", "users"
end
