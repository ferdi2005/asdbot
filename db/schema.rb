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

ActiveRecord::Schema.define(version: 2021_12_30_130749) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "asds", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "sender_id"
    t.bigint "update_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "text"
    t.boolean "nightsend"
    t.integer "multiple_times"
    t.index ["group_id"], name: "index_asds_on_group_id"
    t.index ["sender_id"], name: "index_asds_on_sender_id"
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log"
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "chat_id"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "welcomesent", default: false
    t.boolean "nightsend"
    t.string "title"
    t.boolean "classifica", default: true
    t.boolean "silent", default: false
    t.boolean "admin"
    t.boolean "deletenotasd"
    t.boolean "eliminazione", default: false
  end

  create_table "senders", force: :cascade do |t|
    t.bigint "chat_id"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "classifica", default: true
  end

  create_table "special_events", force: :cascade do |t|
    t.bigint "group_id"
    t.string "text"
    t.bigint "asd_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asd_id"], name: "index_special_events_on_asd_id"
    t.index ["group_id"], name: "index_special_events_on_group_id"
  end

  add_foreign_key "asds", "groups"
  add_foreign_key "asds", "senders"
  add_foreign_key "special_events", "asds"
  add_foreign_key "special_events", "groups"
end
