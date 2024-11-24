# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_23_203037) do
  create_table "apocalypses", force: :cascade do |t|
    t.integer "pet_id", null: false
    t.string "name"
    t.text "description"
    t.string "twist"
    t.string "main_threat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_apocalypses_on_pet_id"
  end

  create_table "events", force: :cascade do |t|
    t.text "description"
    t.integer "success_chance"
    t.integer "apocalypse_id", null: false
    t.string "name"
    t.integer "base_success_chance"
    t.text "reward"
    t.text "consequence"
    t.json "success_modifier_by_stats", default: {"agility"=>0, "strength"=>0, "intelligence"=>0}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apocalypse_id"], name: "index_events_on_apocalypse_id"
  end

  create_table "mini_games", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "base_success_rate", default: 0
    t.integer "apocalypse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apocalypse_id"], name: "index_mini_games_on_apocalypse_id"
  end

  create_table "pet_buffs", force: :cascade do |t|
    t.integer "pet_id", null: false
    t.string "name"
    t.string "effect"
    t.text "description"
    t.text "points"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_pet_buffs_on_pet_id"
  end

  create_table "pet_moods", force: :cascade do |t|
    t.integer "pet_id", null: false
    t.string "name"
    t.string "effect"
    t.text "description"
    t.text "points"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_pet_moods_on_pet_id"
  end

  create_table "pets", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "species"
    t.string "description"
    t.string "class_name"
    t.string "twist"
    t.integer "hunger_level", default: 50
    t.integer "happiness", default: 50
    t.integer "health", default: 50
    t.integer "intelligence", default: 5
    t.integer "agility", default: 5
    t.integer "strength", default: 5
    t.integer "experience", default: 0
    t.integer "level", default: 1
    t.text "abilities_level_unlocked"
    t.text "history_unlocked"
    t.string "mood"
    t.integer "feud"
    t.boolean "retired", default: false
    t.boolean "apocalypse_ready", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pets_on_user_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.text "description"
    t.integer "user_id", null: false
    t.text "secrets_rewards"
    t.text "accomplisments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rewards_on_user_id"
  end

  create_table "user_buffs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "effect"
    t.integer "duration"
    t.text "description"
    t.text "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_buffs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "apocalypses", "pets"
  add_foreign_key "events", "apocalypses"
  add_foreign_key "mini_games", "apocalypses"
  add_foreign_key "pet_buffs", "pets"
  add_foreign_key "pet_moods", "pets"
  add_foreign_key "pets", "users"
  add_foreign_key "rewards", "users"
  add_foreign_key "user_buffs", "users"
end
