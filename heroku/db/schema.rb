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

ActiveRecord::Schema.define(version: 20140528105222) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feed_item_forwadings", force: true do |t|
    t.integer  "feed_item_id"
    t.string   "to_org_id"
    t.string   "to_user_id",                        null: false
    t.string   "fowarding_feed_id",                 null: false
    t.boolean  "is_replied",        default: false
    t.text     "reply_body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_item_forwadings", ["fowarding_feed_id"], name: "index_feed_item_forwadings_on_fowarding_feed_id", using: :btree
  add_index "feed_item_forwadings", ["to_user_id"], name: "index_feed_item_forwadings_on_to_user_id", using: :btree

  create_table "feed_items", force: true do |t|
    t.string   "user_id",    null: false
    t.string   "org_id"
    t.string   "feed_id",    null: false
    t.text     "feed_body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_items", ["feed_id"], name: "index_feed_items_on_feed_id", using: :btree
  add_index "feed_items", ["user_id"], name: "index_feed_items_on_user_id", using: :btree

  create_table "reply_texts", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider",                                 null: false
    t.string   "uid",                                      null: false
    t.string   "user_id",                                  null: false
    t.string   "org_id",                                   null: false
    t.string   "nick_name"
    t.string   "email"
    t.string   "instance_url",                             null: false
    t.string   "token",         limit: 500,                null: false
    t.string   "refresh_token", limit: 500,                null: false
    t.boolean  "is_valid",                  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree
  add_index "users", ["user_id"], name: "index_users_on_user_id", using: :btree

end
