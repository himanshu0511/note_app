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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150514092924) do

  create_table "note_sharings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "note_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notes", :force => true do |t|
    t.string   "heading"
    t.text     "body"
    t.integer  "created_by_id"
    t.integer  "type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "subsribptions", :force => true do |t|
    t.integer  "suscriber_id"
    t.integer  "suscribed_from_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "subsribptions", ["suscribed_from_id"], :name => "index_subsribptions_on_suscribed_from_id"
  add_index "subsribptions", ["suscriber_id"], :name => "index_subsribptions_on_suscriber_id"

  create_table "users", :force => true do |t|
    t.string   "full_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
