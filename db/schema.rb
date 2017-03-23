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

ActiveRecord::Schema.define(version: 20170322225305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alert_filters", force: :cascade do |t|
    t.string   "title"
    t.integer  "question_id"
    t.string   "answer"
    t.integer  "alert_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "condition"
    t.index ["alert_id"], name: "index_alert_filters_on_alert_id", using: :btree
    t.index ["question_id"], name: "index_alert_filters_on_question_id", using: :btree
  end

  create_table "alerts", force: :cascade do |t|
    t.string   "from"
    t.string   "subject"
    t.string   "body"
    t.string   "to"
    t.integer  "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_alerts_on_survey_id", using: :btree
  end

  create_table "answer_dates", force: :cascade do |t|
    t.date     "response"
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_answer_dates_on_answer_id", using: :btree
  end

  create_table "answer_images", force: :cascade do |t|
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "image_id"
    t.index ["answer_id"], name: "index_answer_images_on_answer_id", using: :btree
    t.index ["image_id"], name: "index_answer_images_on_image_id", using: :btree
  end

  create_table "answer_multiples", force: :cascade do |t|
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_answer_multiples_on_answer_id", using: :btree
  end

  create_table "answer_opens", force: :cascade do |t|
    t.text     "response"
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_answer_opens_on_answer_id", using: :btree
  end

  create_table "answer_raitings", force: :cascade do |t|
    t.integer  "response"
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "raiting_id"
    t.index ["answer_id"], name: "index_answer_raitings_on_answer_id", using: :btree
    t.index ["raiting_id"], name: "index_answer_raitings_on_raiting_id", using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "submission_id"
    t.integer  "question_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["question_id"], name: "index_answers_on_question_id", using: :btree
    t.index ["submission_id"], name: "index_answers_on_submission_id", using: :btree
  end

  create_table "choice_answers", force: :cascade do |t|
    t.integer  "answer_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "answer_multiple_id"
    t.integer  "choice_id"
    t.index ["answer_id"], name: "index_choice_answers_on_answer_id", using: :btree
    t.index ["answer_multiple_id"], name: "index_choice_answers_on_answer_multiple_id", using: :btree
    t.index ["choice_id"], name: "index_choice_answers_on_choice_id", using: :btree
  end

  create_table "choices", force: :cascade do |t|
    t.string   "title"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_choices_on_question_id", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "surveys_count",   default: 0
    t.datetime "archived_at"
    t.string   "username"
    t.string   "password_digest"
    t.string   "api_key"
    t.string   "avatar"
    t.index ["user_id"], name: "index_customers_on_user_id", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.string   "file"
    t.integer  "imageable_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "imageable_type"
    t.string   "reference_path"
    t.string   "name"
    t.index ["imageable_id"], name: "index_images_on_imageable_id", using: :btree
  end

  create_table "option_answers", force: :cascade do |t|
    t.integer  "answer_id"
    t.integer  "option_id"
    t.integer  "choice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_option_answers_on_answer_id", using: :btree
    t.index ["choice_id"], name: "index_option_answers_on_choice_id", using: :btree
    t.index ["option_id"], name: "index_option_answers_on_option_id", using: :btree
  end

  create_table "options", force: :cascade do |t|
    t.string   "title"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_options_on_question_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.integer  "survey_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "question_type"
    t.integer  "answers_count", default: 0
    t.integer  "position"
    t.string   "info_image"
    t.text     "info_body"
    t.index ["survey_id"], name: "index_questions_on_survey_id", using: :btree
  end

  create_table "raitings", force: :cascade do |t|
    t.string   "name"
    t.integer  "range"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_raitings_on_question_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "role"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_roles_on_customer_id", using: :btree
    t.index ["user_id"], name: "index_roles_on_user_id", using: :btree
  end

  create_table "submission_views", force: :cascade do |t|
    t.integer  "survey_id"
    t.integer  "user_id"
    t.string   "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_submission_views_on_survey_id", using: :btree
    t.index ["user_id"], name: "index_submission_views_on_user_id", using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "survey_id"
    t.integer  "sender_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "complete",    default: false
    t.string   "sender_type"
    t.index ["sender_id"], name: "index_submissions_on_sender_id", using: :btree
    t.index ["survey_id"], name: "index_submissions_on_survey_id", using: :btree
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "customer_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "questions_count",   default: 0
    t.string   "avatar"
    t.datetime "archived_at"
    t.integer  "submissions_count", default: 0
    t.index ["customer_id"], name: "index_surveys_on_customer_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "api_key"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "admin",           default: false
    t.string   "image"
    t.datetime "archived_at"
  end

  add_foreign_key "alert_filters", "alerts"
  add_foreign_key "alert_filters", "questions"
  add_foreign_key "alerts", "surveys"
  add_foreign_key "answer_dates", "answers"
  add_foreign_key "answer_images", "answers"
  add_foreign_key "answer_multiples", "answers"
  add_foreign_key "answer_opens", "answers"
  add_foreign_key "answer_raitings", "answers"
  add_foreign_key "answer_raitings", "raitings"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "submissions"
  add_foreign_key "choice_answers", "answer_multiples"
  add_foreign_key "choice_answers", "answers"
  add_foreign_key "choices", "questions"
  add_foreign_key "customers", "users"
  add_foreign_key "images", "questions", column: "imageable_id"
  add_foreign_key "option_answers", "answers"
  add_foreign_key "option_answers", "choices"
  add_foreign_key "option_answers", "options"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "surveys"
  add_foreign_key "raitings", "questions"
  add_foreign_key "roles", "customers"
  add_foreign_key "roles", "users"
  add_foreign_key "submission_views", "surveys"
  add_foreign_key "submission_views", "users"
  add_foreign_key "submissions", "surveys"
  add_foreign_key "surveys", "customers"
end
