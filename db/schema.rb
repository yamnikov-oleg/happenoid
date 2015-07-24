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

ActiveRecord::Schema.define(version: 20150724150119) do

  create_table "admin_passwords", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string   "title"
    t.integer  "rating"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "verified"
  end

  add_index "stories", ["verified"], name: "index_stories_on_verified"

  create_table "stories_tags", force: :cascade do |t|
    t.integer "story_id"
    t.integer "tag_id"
  end

  add_index "stories_tags", ["story_id"], name: "index_stories_tags_on_story_id"
  add_index "stories_tags", ["tag_id"], name: "index_stories_tags_on_tag_id"

  create_table "tags", force: :cascade do |t|
    t.string   "short"
    t.string   "full"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
