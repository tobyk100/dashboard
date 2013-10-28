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

ActiveRecord::Schema.define(version: 20131028230240) do

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "level_id"
    t.string   "action"
    t.string   "data",        limit: 20000
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attempt"
    t.integer  "time"
    t.integer  "test_result"
  end

  add_index "activities", ["user_id", "level_id"], name: "index_activities_on_user_id_and_level_id", using: :btree

  create_table "callouts", force: true do |t|
    t.string   "element_id", limit: 1024, null: false
    t.string   "text",       limit: 1024, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "qtip_at"
    t.string   "qtip_my"
  end

  create_table "concepts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_id"
  end

  create_table "concepts_levels", force: true do |t|
    t.integer "concept_id"
    t.integer "level_id"
  end

  create_table "followers", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "student_user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
  end

  add_index "followers", ["student_user_id"], name: "index_followers_on_student_user_id", using: :btree
  add_index "followers", ["user_id", "student_user_id"], name: "index_followers_on_user_id_and_student_user_id", unique: true, using: :btree

  create_table "games", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "base_url"
    t.string   "app"
    t.integer  "intro_video_id"
  end

  create_table "levels", force: true do |t|
    t.integer  "game_id"
    t.string   "name"
    t.string   "level_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "level_num"
    t.string   "skin"
  end

  create_table "script_levels", force: true do |t|
    t.integer  "level_id",     null: false
    t.integer  "script_id",    null: false
    t.integer  "chapter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_chapter"
  end

  create_table "scripts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wrapup_video_id"
    t.boolean  "trophies",        default: false, null: false
    t.boolean  "hidden",          default: false, null: false
  end

  create_table "sections", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  add_index "sections", ["code"], name: "index_sections_on_code", unique: true, using: :btree
  add_index "sections", ["user_id", "name"], name: "index_sections_on_user_id_and_name", unique: true, using: :btree

  create_table "trophies", force: true do |t|
    t.string   "name"
    t.string   "image_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trophies", ["name"], name: "index_trophies_on_name", unique: true, using: :btree

  create_table "user_levels", force: true do |t|
    t.integer  "user_id",                 null: false
    t.integer  "level_id",                null: false
    t.integer  "attempts",    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "best_result"
  end

  add_index "user_levels", ["user_id", "level_id"], name: "index_user_levels_on_user_id_and_level_id", unique: true, using: :btree

  create_table "user_trophies", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "trophy_id",  null: false
    t.integer  "concept_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_trophies", ["user_id", "trophy_id", "concept_id"], name: "index_user_trophies_on_user_id_and_trophy_id_and_concept_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                               default: "",        null: false
    t.string   "encrypted_password",                  default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "admin"
    t.string   "gender",                 limit: 1
    t.string   "name"
    t.string   "locale",                 limit: 10,   default: "en-US",   null: false
    t.date     "birthday"
    t.string   "parent_email"
    t.string   "user_type",              limit: 16,   default: "student"
    t.string   "school"
    t.string   "full_address",           limit: 1024
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "lat"
    t.float    "lon"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "videos", force: true do |t|
    t.string   "key"
    t.string   "youtube_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
