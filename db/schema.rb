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

ActiveRecord::Schema.define(version: 20161206174449) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_dates", force: :cascade do |t|
    t.date     "response"
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_answer_dates_on_answer_id", using: :btree
  end

  create_table "answer_images", force: :cascade do |t|
    t.integer  "image_id"
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["answer_id"], name: "index_answer_raitings_on_answer_id", using: :btree
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
    t.integer  "choice_id"
    t.integer  "answer_id"
    t.integer  "answer_multiple_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
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
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_customers_on_user_id", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.string   "file"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_images_on_question_id", using: :btree
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

  create_table "question_types", force: :cascade do |t|
    t.string   "name"
    t.string   "prefix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.integer  "question_type_id"
    t.integer  "survey_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["question_type_id"], name: "index_questions_on_question_type_id", using: :btree
    t.index ["survey_id"], name: "index_questions_on_survey_id", using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "survey_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_submissions_on_survey_id", using: :btree
    t.index ["user_id"], name: "index_submissions_on_user_id", using: :btree
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_surveys_on_customer_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "api_key"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "answer_dates", "answers"
  add_foreign_key "answer_images", "answers"
  add_foreign_key "answer_images", "images"
  add_foreign_key "answer_multiples", "answers"
  add_foreign_key "answer_opens", "answers"
  add_foreign_key "answer_raitings", "answers"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "submissions"
  add_foreign_key "choice_answers", "answer_multiples"
  add_foreign_key "choice_answers", "answers"
  add_foreign_key "choice_answers", "choices"
  add_foreign_key "choices", "questions"
  add_foreign_key "customers", "users"
  add_foreign_key "images", "questions"
  add_foreign_key "option_answers", "answers"
  add_foreign_key "option_answers", "choices"
  add_foreign_key "option_answers", "options"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "question_types"
  add_foreign_key "questions", "surveys"
  add_foreign_key "submissions", "surveys"
  add_foreign_key "submissions", "users"
  add_foreign_key "surveys", "customers"
end
