class CreateTianhua2020s < ActiveRecord::Migration[6.1]
  def change
    create_table :tianhua2020s do |t|
      t.string :name
      t.string :clerkcode, null: false
      t.datetime :p1_firstday
      t.double :p3_workrate
      t.int :p4_busymonth
      t.string :p4_workcom
      t.string :p4_busyweek
      t.int :p6_prjno
      t.double :p6_totalarea
      t.string :p6_city
      t.string :p6_hometown
      t.string :p7_coworkprj
      t.string :p7_customer
      t.string :p8_design_prj
      t.string :p8_design_award
      t.int :p9_design_meeting_times
      t.double :p9_design_meeting_score
      t.double :p9_design_meeting_rate
      t.int :p10_course_number
      t.double :p11_study_time
      t.double :p11_study_point
      t.double :p11_finish_course
      t.string :p11_study_award
      t.int :p12_KM_login_times
      t.int :p12_KM_login_date
      t.string :p12_KM_pop_part
      t.string :p13_new_title
      t.string :p14_coparter_org
      t.string :p14_coparter_dept
      t.string :p14_coparter
      t.int :p14_cohours
      t.string :p14_coprj
      t.int :p15_reimburse
      t.int :p15_7777
      t.string :p16_adviser
      t.string :p16_teacher
      t.int :p17_oa_task
      t.int :p17_oa_login
      t.int :p17_oa_PV

      t.timestamps
    end
  end
end
