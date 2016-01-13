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

ActiveRecord::Schema.define(version: 20160113210437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archives", force: :cascade do |t|
    t.integer  "year"
    t.date     "published_on"
    t.datetime "extracted_at"
    t.datetime "imported_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "archives", ["published_on", "year"], name: "index_archives_on_published_on_and_year", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "publications", force: :cascade do |t|
    t.integer  "biuletyn"
    t.integer  "pozycja"
    t.date     "data_publikacji"
    t.string   "nazwa"
    t.string   "ulica"
    t.string   "nr_domu"
    t.string   "nr_miesz"
    t.string   "miejscowosc"
    t.string   "kod_poczt"
    t.string   "wojewodztwo"
    t.string   "tel"
    t.string   "fax"
    t.string   "regon"
    t.string   "e_mail"
    t.string   "ogloszenie"
    t.string   "przedmiot_zam"
    t.text     "properties"
    t.integer  "archive_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
