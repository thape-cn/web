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

ActiveRecord::Schema.define(version: 2021_01_12_063659) do

  create_table "tianhua2020s", force: :cascade do |t|
    t.string "name"
    t.string "clerkcode", null: false
    t.datetime "p1_firstday"
    t.float "p3_workrate"
    t.integer "p4_busymonth"
    t.string "p4_workcom"
    t.string "p4_busyweek"
    t.integer "p6_prjno"
    t.float "p6_totalarea"
    t.string "p6_city"
    t.string "p6_hometown"
    t.string "p7_coworkprj"
    t.string "p7_customer"
    t.string "p8_design_prj"
    t.string "p8_design_award"
    t.integer "p9_design_meeting_times"
    t.float "p9_design_meeting_score"
    t.float "p9_design_meeting_rate"
    t.integer "p10_course_number"
    t.float "p11_study_time"
    t.float "p11_study_point"
    t.float "p11_finish_course"
    t.string "p11_study_award"
    t.integer "p12_km_login_times"
    t.integer "p12_km_login_date"
    t.string "p12_km_pop_part"
    t.string "p13_new_title"
    t.string "p14_coparter_org"
    t.string "p14_coparter_dept"
    t.string "p14_coparter"
    t.integer "p14_cohours"
    t.string "p14_coprj"
    t.integer "p15_reimburse"
    t.integer "p15_7777"
    t.string "p16_adviser"
    t.string "p16_teacher"
    t.integer "p17_oa_task"
    t.integer "p17_oa_login"
    t.integer "p17_oa_pv"
    t.string "p10_teacher_level"
    t.float "p11_study_rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
