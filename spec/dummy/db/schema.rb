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

ActiveRecord::Schema.define(:version => 20110527184644) do

  create_table "attachers", :force => true do |t|
    t.integer  "attachment_id"
    t.string   "attachment_type"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.integer  "position",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "goods", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  add_index "goods", ["cached_slug"], :name => "index_goods_on_cached_slug", :unique => true

  create_table "goods_option_types", :id => false, :force => true do |t|
    t.integer "good_id",        :null => false
    t.integer "option_type_id", :null => false
  end

  create_table "images", :force => true do |t|
    t.string   "name",           :null => false
    t.string   "image_file_uid", :null => false
    t.string   "crop_values"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "option_types", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "position",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "option_values", :force => true do |t|
    t.integer  "option_type_id", :null => false
    t.string   "name",           :null => false
    t.integer  "position",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "option_values_variants", :id => false, :force => true do |t|
    t.integer "option_value_id", :null => false
    t.integer "variant_id",      :null => false
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "variants", :force => true do |t|
    t.integer  "good_id",                           :null => false
    t.boolean  "is_master",      :default => false
    t.string   "sku",                               :null => false
    t.integer  "price_in_cents", :default => 0,     :null => false
    t.string   "currency",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "variants", ["sku"], :name => "index_variants_on_sku", :unique => true

end
