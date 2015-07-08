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

ActiveRecord::Schema.define(version: 20150704031744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "account_streams", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.integer  "stream_id",  null: false
    t.string   "status",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "account_streams", ["account_id"], name: "index_account_streams_on_account_id", using: :btree
  add_index "account_streams", ["stream_id"], name: "index_account_streams_on_stream_id", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.citext   "name",       null: false
    t.string   "email",      null: false
    t.string   "icon_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["name"], name: "index_accounts_on_name", unique: true, using: :btree

  create_table "photo_streams", force: :cascade do |t|
    t.integer  "photo_id",   null: false
    t.integer  "stream_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "photo_streams", ["photo_id"], name: "index_photo_streams_on_photo_id", using: :btree
  add_index "photo_streams", ["stream_id"], name: "index_photo_streams_on_stream_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "account_id",      null: false
    t.string   "key",             null: false
    t.string   "private_name",    null: false
    t.string   "filename",        null: false
    t.integer  "size"
    t.string   "content_type"
    t.binary   "original_header"
    t.datetime "shot_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "photos", ["account_id"], name: "index_photos_on_account_id", using: :btree
  add_index "photos", ["key"], name: "index_photos_on_key", unique: true, using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "signs", force: :cascade do |t|
    t.string   "email",      null: false
    t.string   "token"
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "signs", ["email"], name: "index_signs_on_email", unique: true, using: :btree
  add_index "signs", ["token"], name: "index_signs_on_token", unique: true, using: :btree

  create_table "streams", force: :cascade do |t|
    t.string   "key",        null: false
    t.string   "title",      null: false
    t.json     "log",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "streams", ["key"], name: "index_streams_on_key", unique: true, using: :btree

  add_foreign_key "account_streams", "accounts"
  add_foreign_key "account_streams", "streams"
  add_foreign_key "photo_streams", "photos"
  add_foreign_key "photo_streams", "streams"
end
