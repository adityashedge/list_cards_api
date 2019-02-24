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

ActiveRecord::Schema.define(version: 2019_02_24_125251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "cards", primary_key: "card_id", force: :cascade do |t|
    t.uuid "uuid"
    t.string "title"
    t.text "description"
    t.bigint "owner_id"
    t.bigint "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count", default: 0, null: false
    t.index ["comments_count"], name: "index_cards_on_comments_count"
    t.index ["list_id"], name: "index_cards_on_list_id"
    t.index ["owner_id"], name: "index_cards_on_owner_id"
    t.index ["uuid"], name: "index_cards_on_uuid", unique: true
  end

  create_table "comments", primary_key: "comment_id", force: :cascade do |t|
    t.uuid "uuid"
    t.text "description"
    t.integer "comments_count", default: 0, null: false
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["comments_count"], name: "index_comments_on_comments_count"
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["uuid"], name: "index_comments_on_uuid", unique: true
  end

  create_table "devices", primary_key: "device_id", force: :cascade do |t|
    t.string "uuid"
    t.string "device_identifier"
    t.string "auth_token"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "sign_in_count", default: 0, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth_token"], name: "index_devices_on_auth_token", unique: true
    t.index ["device_identifier"], name: "index_devices_on_device_identifier"
    t.index ["user_id", "device_identifier"], name: "index_devices_on_user_id_and_device_identifier", unique: true
    t.index ["user_id"], name: "index_devices_on_user_id"
    t.index ["uuid"], name: "index_devices_on_uuid", unique: true
  end

  create_table "lists", primary_key: "list_id", force: :cascade do |t|
    t.uuid "uuid"
    t.string "title"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_lists_on_owner_id"
  end

  create_table "lists_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "list_id", null: false
    t.index ["list_id"], name: "index_lists_users_on_list_id"
    t.index ["user_id"], name: "index_lists_users_on_user_id"
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.uuid "uuid"
    t.string "name"
    t.string "user_type", default: "member"
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email_unique", unique: true
    t.index "lower((username)::text)", name: "index_users_on_lower_username_unique", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_type"], name: "index_users_on_user_type"
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
