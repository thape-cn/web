# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_26_081705) do

  create_table "about_page_translations", force: :cascade do |t|
    t.integer "about_page_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "thape_intro"
    t.index ["about_page_id"], name: "index_about_page_translations_on_about_page_id"
    t.index ["locale"], name: "index_about_page_translations_on_locale"
  end

  create_table "about_pages", force: :cascade do |t|
    t.text "thape_intro"
    t.string "about_h1"
    t.string "about_h1_mobile"
    t.string "about_h2"
    t.string "about_h2_mobile"
    t.string "about_h3"
    t.string "about_h3_mobile"
    t.string "about_h4"
    t.string "about_h4_mobile"
    t.string "about_h5"
    t.string "about_h5_mobile"
    t.string "about_h6"
    t.string "about_h6_mobile"
    t.string "about_h7"
    t.string "about_h7_mobile"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "about_translations", force: :cascade do |t|
    t.integer "about_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "about_title"
    t.text "about_content"
    t.string "about_img_alt"
    t.index ["about_id"], name: "index_about_translations_on_about_id"
    t.index ["locale"], name: "index_about_translations_on_locale"
  end

  create_table "abouts", force: :cascade do |t|
    t.string "about_title"
    t.text "about_content"
    t.string "about_img"
    t.string "about_img_alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "case_pictures", force: :cascade do |t|
    t.integer "case_id"
    t.string "album"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_case_pictures_on_case_id"
  end

  create_table "cases", force: :cascade do |t|
    t.string "title"
    t.string "market"
    t.string "snapshot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "professional"
    t.text "other"
    t.integer "position", default: 0
    t.string "seo_title"
    t.string "seo_keywords"
    t.string "seo_description"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.string "china_area_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url_name"
    t.string "company_name"
    t.integer "company_position"
  end

  create_table "city_people", force: :cascade do |t|
    t.integer "city_id"
    t.integer "person_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "city_title"
    t.boolean "is_management", default: false
    t.boolean "is_professional", default: false
    t.string "city_en_title"
    t.index ["city_id"], name: "index_city_people_on_city_id"
    t.index ["person_id"], name: "index_city_people_on_person_id"
  end

  create_table "guest_messages", force: :cascade do |t|
    t.text "message"
    t.string "name"
    t.string "company"
    t.string "contact_details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "homes", force: :cascade do |t|
    t.string "banner_1"
    t.string "title_1"
    t.string "subtitle_1"
    t.string "banner_2"
    t.string "title_2"
    t.string "subtitle_2"
    t.string "banner_3"
    t.string "title_3"
    t.string "subtitle_3"
    t.string "banner_4"
    t.string "title_4"
    t.string "subtitle_4"
    t.string "banner_5"
    t.string "title_5"
    t.string "subtitle_5"
    t.string "project_img_1"
    t.string "project_title_1"
    t.string "project_subtitle_1"
    t.string "project_link_1"
    t.string "project_img_2"
    t.string "project_title_2"
    t.string "project_subtitle_2"
    t.string "project_link_2"
    t.string "project_img_3"
    t.string "project_title_3"
    t.string "project_subtitle_3"
    t.string "project_link_3"
    t.string "info_img_1"
    t.string "info_title_1"
    t.string "info_subtitle_1"
    t.string "info_link_1"
    t.string "info_img_2"
    t.string "info_title_2"
    t.string "info_subtitle_2"
    t.string "info_link_2"
    t.string "info_img_3"
    t.string "info_title_3"
    t.string "info_subtitle_3"
    t.string "info_link_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "banner_phone_1"
    t.string "banner_phone_2"
    t.string "banner_phone_3"
    t.string "banner_phone_4"
    t.string "banner_phone_5"
    t.string "project_phone_img_1"
    t.string "project_phone_img_2"
    t.string "project_phone_img_3"
    t.string "banner_alt_1"
    t.string "banner_alt_2"
    t.string "banner_alt_3"
    t.string "banner_alt_4"
    t.string "banner_alt_5"
    t.string "project_alt_1"
    t.string "project_alt_2"
    t.string "project_alt_3"
    t.string "info_alt_1"
    t.string "info_alt_2"
    t.string "info_alt_3"
    t.string "info_high_img"
    t.string "info_high_title"
    t.text "info_high_introduction"
    t.string "info_high_link"
    t.string "info_high_phone_img"
  end

  create_table "infos", force: :cascade do |t|
    t.string "title"
    t.text "introduction"
    t.text "content"
    t.string "picture"
    t.integer "category"
    t.integer "pushlist"
    t.string "banner"
    t.string "snapshot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0
    t.string "snapshot_alt"
    t.string "banner_alt"
    t.boolean "hide_in_design_staff_news", default: false
    t.boolean "hide_in_index_news", default: false
    t.string "seo_title"
    t.string "seo_keywords"
    t.string "seo_description"
    t.string "sub_title"
    t.string "pdf_file"
  end

  create_table "map_contact_translations", force: :cascade do |t|
    t.integer "map_contact_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "address"
    t.string "tel"
    t.string "fax"
    t.string "long_name"
    t.string "alt_name"
    t.string "website_name"
    t.index ["locale"], name: "index_map_contact_translations_on_locale"
    t.index ["map_contact_id"], name: "index_map_contact_translations_on_map_contact_id"
  end

  create_table "map_contacts", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "tel"
    t.string "fax"
    t.string "long_name"
    t.string "alt_name"
    t.string "media_phone"
    t.string "marketing_phone"
    t.string "website_url"
  end

  create_table "people", force: :cascade do |t|
    t.integer "category"
    t.integer "line"
    t.string "avatar"
    t.string "photo"
    t.string "name"
    t.string "title"
    t.text "introduce"
    t.string "works"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url_name"
    t.integer "position", default: 0
    t.date "leaving_date"
    t.boolean "in_old_web", default: false
  end

  create_table "person_translations", force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "title"
    t.text "introduce"
    t.index ["locale"], name: "index_person_translations_on_locale"
    t.index ["person_id"], name: "index_person_translations_on_person_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "image"
    t.integer "info_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["info_id"], name: "index_pictures_on_info_id"
  end

  create_table "project_types", force: :cascade do |t|
    t.string "cn_name"
    t.string "en_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "residential_types", force: :cascade do |t|
    t.string "cn_name"
    t.string "en_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "seos", force: :cascade do |t|
    t.string "home_title"
    t.text "description"
    t.text "abstract"
    t.text "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "about_title"
    t.string "management_title"
    t.string "designing_title"
    t.string "contact_title"
    t.string "seo_name"
  end

  create_table "service_file_translations", force: :cascade do |t|
    t.integer "service_file_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "building_intro"
    t.string "interior_intro"
    t.string "planning_intro"
    t.string "landscape_intro"
    t.string "vetting_intro"
    t.string "consluting_intro"
    t.string "vrtech_intro"
    t.index ["locale"], name: "index_service_file_translations_on_locale"
    t.index ["service_file_id"], name: "index_service_file_translations_on_service_file_id"
  end

  create_table "service_files", force: :cascade do |t|
    t.string "interior_intro_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "building_intro"
    t.text "interior_intro"
    t.text "planning_intro"
    t.text "landscape_intro"
    t.text "vetting_intro"
    t.text "consluting_intro"
    t.text "vrtech_intro"
  end

  create_table "tail_homes", force: :cascade do |t|
    t.string "new_project_photo_1"
    t.string "new_project_photo_2l"
    t.string "new_project_photo_3w"
    t.string "new_project_photo_4"
    t.string "new_project_photo_5"
    t.string "new_project_photo_6"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "hero_news_photo"
    t.integer "hero_news_id"
    t.integer "hero_news_title_cap"
    t.integer "new_project_1_id"
    t.integer "new_project_2_id"
    t.integer "new_project_3_id"
    t.integer "new_project_4_id"
    t.integer "new_project_5_id"
    t.integer "new_project_6_id"
    t.integer "info_1_id"
    t.integer "info_2_id"
    t.integer "info_3_id"
    t.string "info_1_photo"
    t.string "info_2_photo"
    t.string "info_3_photo"
    t.string "background_1"
    t.string "background_2"
    t.string "background_3"
    t.string "background_4"
    t.string "background_5"
    t.string "background_6"
    t.string "background_1_mobile"
    t.string "background_2_mobile"
    t.string "background_3_mobile"
    t.string "background_4_mobile"
    t.string "background_5_mobile"
    t.string "background_6_mobile"
    t.string "background_1_pad"
    t.string "background_2_pad"
    t.string "background_3_pad"
    t.string "background_4_pad"
    t.string "background_5_pad"
    t.string "background_6_pad"
    t.string "background_1_webp"
    t.string "background_2_webp"
    t.string "background_3_webp"
    t.string "background_4_webp"
    t.string "background_5_webp"
    t.string "background_6_webp"
    t.string "background_1_mobile_webp"
    t.string "background_2_mobile_webp"
    t.string "background_3_mobile_webp"
    t.string "background_4_mobile_webp"
    t.string "background_5_mobile_webp"
    t.string "background_6_mobile_webp"
    t.string "background_1_pad_webp"
    t.string "background_2_pad_webp"
    t.string "background_3_pad_webp"
    t.string "background_4_pad_webp"
    t.string "background_5_pad_webp"
    t.string "background_6_pad_webp"
    t.string "hero_news_photo_mobile"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "work_pictures", force: :cascade do |t|
    t.string "album_jpg"
    t.string "album_webp"
    t.integer "work_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["work_id"], name: "index_work_pictures_on_work_id"
  end

  create_table "work_project_types", force: :cascade do |t|
    t.integer "work_id", null: false
    t.integer "project_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_type_id"], name: "index_work_project_types_on_project_type_id"
    t.index ["work_id"], name: "index_work_project_types_on_work_id"
  end

  create_table "work_residential_types", force: :cascade do |t|
    t.integer "work_id", null: false
    t.integer "residential_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["residential_type_id"], name: "index_work_residential_types_on_residential_type_id"
    t.index ["work_id"], name: "index_work_residential_types_on_work_id"
  end

  create_table "work_translations", force: :cascade do |t|
    t.integer "work_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "project_name"
    t.string "client"
    t.string "services"
    t.string "team"
    t.string "cooperation"
    t.string "awards"
    t.string "design_completion_lines"
    t.string "construction_completion_lines"
    t.string "architecture_area_lines"
    t.index ["locale"], name: "index_work_translations_on_locale"
    t.index ["work_id"], name: "index_work_translations_on_work_id"
  end

  create_table "work_type_pages", force: :cascade do |t|
    t.string "resdential_jpg"
    t.string "resdential_webp"
    t.string "demonstration_zone_jpg"
    t.string "demonstration_zone_webp"
    t.string "mixed_used_tod_jpg"
    t.string "mixed_used_tod_webp"
    t.string "commercial_jpg"
    t.string "commercial_webp"
    t.string "supertall_jpg"
    t.string "supertall_webp"
    t.string "cultural_jpg"
    t.string "cultural_webp"
    t.string "education_jpg"
    t.string "education_webp"
    t.string "office_jpg"
    t.string "office_webp"
    t.string "urban_design_jpg"
    t.string "urban_design_webp"
    t.string "medical_care_jpg"
    t.string "medical_care_webp"
    t.string "hospitality_jpg"
    t.string "hospitality_webp"
    t.string "urban_planning_jpg"
    t.string "urban_planning_webp"
    t.string "landscape_jpg"
    t.string "landscape_webp"
    t.string "interior_jpg"
    t.string "interior_webp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cultural_wide_jpg"
    t.string "cultural_wide_webp"
  end

  create_table "works", force: :cascade do |t|
    t.date "design_completion"
    t.date "construction_completion"
    t.integer "city_id", null: false
    t.integer "site_area"
    t.decimal "planning_area"
    t.integer "architecture_area"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "snapshot_jpg"
    t.string "snapshot_webp"
    t.boolean "published", default: true
    t.integer "position"
    t.index ["city_id"], name: "index_works_on_city_id"
  end

  add_foreign_key "case_pictures", "cases"
  add_foreign_key "pictures", "infos"
  add_foreign_key "work_pictures", "works"
  add_foreign_key "work_project_types", "project_types"
  add_foreign_key "work_project_types", "works"
  add_foreign_key "work_residential_types", "residential_types"
  add_foreign_key "work_residential_types", "works"
  add_foreign_key "works", "cities"
end
