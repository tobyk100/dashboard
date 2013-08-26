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

ActiveRecord::Schema.define(version: 20130821224522) do

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "level_id"
    t.string   "action"
    t.string   "data"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stars"
    t.integer  "attempt"
    t.integer  "time"
  end

  add_index "activities", ["user_id", "level_id"], name: "index_activities_on_user_id_and_level_id", using: :btree

  create_table "concepts", force: true do |t|
    t.string   "name"
    t.string   "description", limit: 1024
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concepts_levels", force: true do |t|
    t.integer "concept_id"
    t.integer "level_id"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "base_url"
  end

  create_table "levels", force: true do |t|
    t.integer  "game_id"
    t.string   "name"
    t.string   "level_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level_num"
  end

  create_table "script_levels", force: true do |t|
    t.integer  "level_id",   null: false
    t.integer  "script_id",  null: false
    t.integer  "chapter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scripts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_levels", force: true do |t|
    t.integer  "user_id",                null: false
    t.integer  "level_id",               null: false
    t.integer  "attempts",   default: 0, null: false
    t.integer  "stars",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_levels", ["user_id", "level_id"], name: "index_user_levels_on_user_id_and_level_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                            default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0
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
    t.string   "language",               limit: 2
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
