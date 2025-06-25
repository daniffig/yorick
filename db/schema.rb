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

ActiveRecord::Schema[7.1].define(version: 2025_04_10_012235) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "funeral_notices", force: :cascade do |t|
    t.string "full_name"
    t.text "content"
    t.date "published_on"
    t.string "source_link"
    t.string "hash_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hash_id"], name: "index_funeral_notices_on_hash_id", unique: true
    t.index ["published_on", "hash_id"], name: "index_funeral_notices_on_published_on_and_hash_id"
  end

end
