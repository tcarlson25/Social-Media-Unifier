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

ActiveRecord::Schema.define(version: 20180309165646) do

  create_table "feeds", force: :cascade do |t|
    t.integer "user_id"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feeds_on_user_id"
  end

  create_table "twitter_posts", id: :string, force: :cascade do |t|
    t.integer "feed_id"
    t.string "name"
    t.string "user_name"
    t.text "content"
    t.string "imgurl"
    t.string "favorite_count"
    t.string "retweet_count"
    t.string "post_made_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_twitter_posts_on_feed_id"
    t.index ["id"], name: "sqlite_autoindex_twitter_posts_1", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "uid"
    t.string "provider"
    t.string "encrypted_token"
    t.string "encrypted_token_iv"
    t.string "encrypted_secret"
    t.string "encrypted_secret_iv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_image"
  end

end
