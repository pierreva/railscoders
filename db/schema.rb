# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 25) do

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "synopsis"
    t.text     "body"
    t.boolean  "published",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "category_id",  :default => 1
  end

  create_table "categories", :force => true do |t|
    t.string "name"
  end

  create_table "comments", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "user_id"
    t.string   "guest_name"
    t.string   "guest_email"
    t.string   "guest_url"
    t.text     "body"
    t.datetime "created_at"
  end

  add_index "comments", ["entry_id"], :name => "index_comments_on_entry_id"

  create_table "emails", :force => true do |t|
    t.string  "from"
    t.string  "to"
    t.integer "last_send_attempt", :default => 0
    t.text    "mail"
  end

  create_table "entries", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.integer  "comments_count", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries", ["user_id"], :name => "index_entries_on_user_id"

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count", :default => 0, :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer "user_id",                             :null => false
    t.integer "friend_id",                           :null => false
    t.boolean "xfn_friend",       :default => false, :null => false
    t.boolean "xfn_acquaintance", :default => false, :null => false
    t.boolean "xfn_contact",      :default => false, :null => false
    t.boolean "xfn_met",          :default => false, :null => false
    t.boolean "xfn_coworker",     :default => false, :null => false
    t.boolean "xfn_colleague",    :default => false, :null => false
    t.boolean "xfn_coresident",   :default => false, :null => false
    t.boolean "xfn_neighbor",     :default => false, :null => false
    t.boolean "xfn_child",        :default => false, :null => false
    t.boolean "xfn_parent",       :default => false, :null => false
    t.boolean "xfn_sibling",      :default => false, :null => false
    t.boolean "xfn_spouse",       :default => false, :null => false
    t.boolean "xfn_kin",          :default => false, :null => false
    t.boolean "xfn_muse",         :default => false, :null => false
    t.boolean "xfn_crush",        :default => false, :null => false
    t.boolean "xfn_date",         :default => false, :null => false
    t.boolean "xfn_sweetheart",   :default => false, :null => false
  end

  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id"

  create_table "newsletters", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.boolean  "sent",       :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.string   "content_type", :limit => 100
    t.string   "filename"
    t.string   "path"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.float    "geo_lat"
    t.float    "geo_long"
    t.boolean  "show_geo",                    :default => true, :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["topic_id"], :name => "index_posts_on_topic_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "posts_count", :default => 0, :null => false
  end

  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"

  create_table "users", :force => true do |t|
    t.string   "username",         :limit => 64,                    :null => false
    t.string   "email",            :limit => 128,                   :null => false
    t.string   "hashed_password",  :limit => 64
    t.boolean  "enabled",                         :default => true, :null => false
    t.text     "profile"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.integer  "posts_count",                     :default => 0,    :null => false
    t.integer  "entries_count",                   :default => 0,    :null => false
    t.string   "blog_title"
    t.boolean  "enable_comments",                 :default => true
    t.integer  "photos_count"
    t.string   "last_activity"
    t.datetime "last_activity_at"
    t.string   "flickr_username"
    t.string   "flickr_id"
  end

  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "usertemplates", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.text    "body"
  end

  add_index "usertemplates", ["user_id", "name"], :name => "index_usertemplates_on_user_id_and_name"

end
