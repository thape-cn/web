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

ActiveRecord::Schema[7.0].define(version: 0) do
  create_table "tianhua2019s", force: :cascade do |t|
    t.string "name"
    t.string "clerkcode"
    t.string "email"
    t.date "firstday"
    t.decimal "fill_rate"
    t.decimal "mean"
    t.decimal "rank"
    t.date "max_month"
    t.string "max_weekday"
    t.string "workno"
    t.integer "prjno"
    t.string "work_place"
    t.string "max_serve_client"
    t.string "max_projectname"
    t.integer "max_workdays"
    t.string "home_town"
    t.string "max_parter_no"
    t.string "max_parter_project1"
    t.integer "max_parter_hours"
    t.string "max_parter_project2"
    t.string "max_parter_project3"
    t.string "max_parter_name"
    t.decimal "study_hours"
    t.integer "learn_course"
    t.decimal "study_rank"
    t.string "certificate"
    t.string "micro_course"
    t.decimal "prj_area"
    t.string "teacher"
    t.string "upgrade_postname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "max_month_unit"
    t.integer "student_no"
    t.integer "learn_times"
    t.string "pop_course"
    t.string "old_folk"
    t.integer "service_times"
    t.string "skywalker"
    t.string "major"
    t.string "best_addin"
    t.string "old_folk_course"
    t.integer "folk_alumni_sign"
    t.string "upgrade_org"
  end

end
