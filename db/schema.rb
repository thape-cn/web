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

ActiveRecord::Schema[7.0].define(version: 2021_12_25_060205) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "about_page_translations", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "about_page_id", null: false
    t.text "locale", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "thape_intro"
    t.index ["about_page_id"], name: "index_about_page_translations_on_about_page_id"
    t.index ["locale"], name: "index_about_page_translations_on_locale"
  end

  create_table "about_pages", id: :bigint, default: nil, force: :cascade do |t|
    t.text "thape_intro"
    t.text "about_h1"
    t.text "about_h1_mobile"
    t.text "about_h2"
    t.text "about_h2_mobile"
    t.text "about_h3"
    t.text "about_h3_mobile"
    t.text "about_h4"
    t.text "about_h4_mobile"
    t.text "about_h5"
    t.text "about_h5_mobile"
    t.text "about_h6"
    t.text "about_h6_mobile"
    t.text "about_h7"
    t.text "about_h7_mobile"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "about_translations", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "about_id", null: false
    t.text "locale", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "about_title"
    t.text "about_content"
    t.text "about_img_alt"
    t.index ["about_id"], name: "index_about_translations_on_about_id"
    t.index ["locale"], name: "index_about_translations_on_locale"
  end

  create_table "abouts", id: :bigint, default: nil, force: :cascade do |t|
    t.text "about_title"
    t.text "about_content"
    t.text "about_img"
    t.text "about_img_alt"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "active_storage_attachments", id: :bigint, default: nil, force: :cascade do |t|
    t.text "name", null: false
    t.text "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :bigint, default: nil, force: :cascade do |t|
    t.text "key", null: false
    t.text "filename", null: false
    t.text "content_type"
    t.text "metadata"
    t.text "service_name", null: false
    t.bigint "byte_size", null: false
    t.text "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.text "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "case_pictures", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "case_id"
    t.text "album"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["case_id"], name: "index_case_pictures_on_case_id"
  end

  create_table "cases", id: :bigint, default: nil, force: :cascade do |t|
    t.text "title"
    t.text "market"
    t.text "snapshot"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "professional"
    t.text "other"
    t.bigint "position", default: 0
    t.text "seo_title"
    t.text "seo_keywords"
    t.text "seo_description"
  end

  create_table "cities", id: :bigint, default: nil, force: :cascade do |t|
    t.text "name"
    t.text "china_area_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "url_name"
    t.text "company_name"
    t.bigint "company_position"
    t.string "company_name_english"
  end

  create_table "city_people", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "city_id"
    t.bigint "person_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "city_title"
    t.boolean "is_management", default: false
    t.boolean "is_professional", default: false
    t.text "city_en_title"
    t.index ["city_id"], name: "index_city_people_on_city_id"
    t.index ["person_id"], name: "index_city_people_on_person_id"
  end

  create_table "flag2020_boards", force: :cascade do |t|
    t.string "from_clerkcode"
    t.string "to_clerkcode"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guest_messages", id: :bigint, default: nil, force: :cascade do |t|
    t.text "message"
    t.text "name"
    t.text "company"
    t.text "contact_details"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "homes", id: :bigint, default: nil, force: :cascade do |t|
    t.text "banner_1"
    t.text "title_1"
    t.text "subtitle_1"
    t.text "banner_2"
    t.text "title_2"
    t.text "subtitle_2"
    t.text "banner_3"
    t.text "title_3"
    t.text "subtitle_3"
    t.text "banner_4"
    t.text "title_4"
    t.text "subtitle_4"
    t.text "banner_5"
    t.text "title_5"
    t.text "subtitle_5"
    t.text "project_img_1"
    t.text "project_title_1"
    t.text "project_subtitle_1"
    t.text "project_link_1"
    t.text "project_img_2"
    t.text "project_title_2"
    t.text "project_subtitle_2"
    t.text "project_link_2"
    t.text "project_img_3"
    t.text "project_title_3"
    t.text "project_subtitle_3"
    t.text "project_link_3"
    t.text "info_img_1"
    t.text "info_title_1"
    t.text "info_subtitle_1"
    t.text "info_link_1"
    t.text "info_img_2"
    t.text "info_title_2"
    t.text "info_subtitle_2"
    t.text "info_link_2"
    t.text "info_img_3"
    t.text "info_title_3"
    t.text "info_subtitle_3"
    t.text "info_link_3"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "banner_phone_1"
    t.text "banner_phone_2"
    t.text "banner_phone_3"
    t.text "banner_phone_4"
    t.text "banner_phone_5"
    t.text "project_phone_img_1"
    t.text "project_phone_img_2"
    t.text "project_phone_img_3"
    t.text "banner_alt_1"
    t.text "banner_alt_2"
    t.text "banner_alt_3"
    t.text "banner_alt_4"
    t.text "banner_alt_5"
    t.text "project_alt_1"
    t.text "project_alt_2"
    t.text "project_alt_3"
    t.text "info_alt_1"
    t.text "info_alt_2"
    t.text "info_alt_3"
    t.text "info_high_img"
    t.text "info_high_title"
    t.text "info_high_introduction"
    t.text "info_high_link"
    t.text "info_high_phone_img"
  end

  create_table "infos", id: :bigint, default: nil, force: :cascade do |t|
    t.text "title"
    t.text "introduction"
    t.text "content"
    t.text "picture"
    t.bigint "category"
    t.bigint "pushlist"
    t.text "banner"
    t.text "snapshot"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "position", default: 0
    t.text "snapshot_alt"
    t.text "banner_alt"
    t.boolean "hide_in_design_staff_news", default: false
    t.boolean "hide_in_index_news", default: false
    t.text "seo_title"
    t.text "seo_keywords"
    t.text "seo_description"
    t.text "sub_title"
    t.text "pdf_file"
  end

  create_table "map_contact_translations", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "map_contact_id", null: false
    t.text "locale", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "name"
    t.text "address"
    t.text "tel"
    t.text "fax"
    t.text "long_name"
    t.text "alt_name"
    t.text "website_name"
    t.index ["locale"], name: "index_map_contact_translations_on_locale"
    t.index ["map_contact_id"], name: "index_map_contact_translations_on_map_contact_id"
  end

  create_table "map_contacts", id: :bigint, default: nil, force: :cascade do |t|
    t.text "name"
    t.text "address"
    t.text "tel"
    t.text "fax"
    t.text "long_name"
    t.text "alt_name"
    t.text "media_phone"
    t.text "marketing_phone"
    t.text "website_url"
  end

  create_table "people", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "category"
    t.bigint "line"
    t.text "avatar"
    t.text "photo"
    t.text "name"
    t.text "title"
    t.text "introduce"
    t.text "works"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "url_name"
    t.bigint "position", default: 0
    t.date "leaving_date"
    t.boolean "in_old_web", default: false
  end

  create_table "person_translations", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.text "locale", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "name"
    t.text "title"
    t.text "introduce"
    t.index ["locale"], name: "index_person_translations_on_locale"
    t.index ["person_id"], name: "index_person_translations_on_person_id"
  end

  create_table "pictures", id: :bigint, default: nil, force: :cascade do |t|
    t.text "image"
    t.bigint "info_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["info_id"], name: "index_pictures_on_info_id"
  end

  create_table "portfolio_translations", force: :cascade do |t|
    t.bigint "portfolio_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "sub_title"
    t.index ["locale"], name: "index_portfolio_translations_on_locale"
    t.index ["portfolio_id"], name: "index_portfolio_translations_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "pdf_file"
    t.string "cover_jpg"
    t.string "cover_webp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pixel_height", default: 900
    t.integer "pixel_width", default: 700
    t.integer "position", default: 0
    t.string "mobile_cover_jpg"
    t.string "mobile_cover_webp"
    t.string "page_cover"
  end

  create_table "project_types", id: :bigint, default: nil, force: :cascade do |t|
    t.text "cn_name"
    t.text "en_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "publication_translations", force: :cascade do |t|
    t.bigint "publication_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "sub_title"
    t.index ["locale"], name: "index_publication_translations_on_locale"
    t.index ["publication_id"], name: "index_publication_translations_on_publication_id"
  end

  create_table "publications", force: :cascade do |t|
    t.integer "category_status", default: 0, null: false
    t.string "pdf_file"
    t.string "cover_jpg"
    t.string "cover_webp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pixel_height", default: 900
    t.integer "pixel_width", default: 700
    t.integer "position", default: 0
    t.string "mobile_cover_jpg"
    t.string "mobile_cover_webp"
    t.string "page_cover"
  end

  create_table "residential_types", id: :bigint, default: nil, force: :cascade do |t|
    t.text "cn_name"
    t.text "en_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "seos", id: :bigint, default: nil, force: :cascade do |t|
    t.text "home_title"
    t.text "description"
    t.text "abstract"
    t.text "keywords"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "about_title"
    t.text "management_title"
    t.text "designing_title"
    t.text "contact_title"
    t.text "seo_name"
  end

  create_table "service_file_translations", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "service_file_id", null: false
    t.text "locale", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "building_intro"
    t.text "interior_intro"
    t.text "planning_intro"
    t.text "landscape_intro"
    t.text "vetting_intro"
    t.text "consluting_intro"
    t.text "vrtech_intro"
    t.index ["locale"], name: "index_service_file_translations_on_locale"
    t.index ["service_file_id"], name: "index_service_file_translations_on_service_file_id"
  end

  create_table "service_files", id: :bigint, default: nil, force: :cascade do |t|
    t.text "interior_intro_file"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "building_intro"
    t.text "interior_intro"
    t.text "planning_intro"
    t.text "landscape_intro"
    t.text "vetting_intro"
    t.text "consluting_intro"
    t.text "vrtech_intro"
    t.string "tianhua_2020_bill_music"
  end

  create_table "tail_homes", id: :bigint, default: nil, force: :cascade do |t|
    t.string "new_project_photo_1"
    t.string "new_project_photo_2l"
    t.string "new_project_photo_3w"
    t.string "new_project_photo_4"
    t.string "new_project_photo_5"
    t.string "new_project_photo_6"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "hero_news_photo"
    t.bigint "hero_news_id"
    t.bigint "hero_news_title_cap"
    t.bigint "new_project_1_id"
    t.bigint "new_project_2_id"
    t.bigint "new_project_3_id"
    t.bigint "new_project_4_id"
    t.bigint "new_project_5_id"
    t.bigint "new_project_6_id"
    t.bigint "info_1_id"
    t.bigint "info_2_id"
    t.bigint "info_3_id"
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
    t.string "background_1_title"
    t.string "background_1_subtitle"
    t.string "background_1_link"
    t.string "background_2_title"
    t.string "background_2_subtitle"
    t.string "background_2_link"
    t.string "background_3_title"
    t.string "background_3_subtitle"
    t.string "background_3_link"
    t.string "background_4_title"
    t.string "background_4_subtitle"
    t.string "background_4_link"
    t.string "background_5_title"
    t.string "background_5_subtitle"
    t.string "background_5_link"
    t.string "background_6_title"
    t.string "background_6_subtitle"
    t.string "background_6_link"
  end

  create_table "users", id: :bigint, default: nil, force: :cascade do |t|
    t.text "name"
    t.text "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "work_pictures", id: :bigint, default: nil, force: :cascade do |t|
    t.text "album_jpg"
    t.text "album_webp"
    t.bigint "work_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["work_id"], name: "index_work_pictures_on_work_id"
  end

  create_table "work_project_types", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "project_type_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["project_type_id"], name: "index_work_project_types_on_project_type_id"
    t.index ["work_id"], name: "index_work_project_types_on_work_id"
  end

  create_table "work_residential_types", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "residential_type_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["residential_type_id"], name: "index_work_residential_types_on_residential_type_id"
    t.index ["work_id"], name: "index_work_residential_types_on_work_id"
  end

  create_table "work_translations", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "work_id", null: false
    t.text "locale", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "project_name"
    t.text "client"
    t.text "services"
    t.text "team"
    t.text "cooperation"
    t.text "awards"
    t.text "design_completion_lines"
    t.text "construction_completion_lines"
    t.text "architecture_area_lines"
    t.index ["locale"], name: "index_work_translations_on_locale"
    t.index ["work_id"], name: "index_work_translations_on_work_id"
  end

  create_table "work_type_pages", id: :bigint, default: nil, force: :cascade do |t|
    t.text "resdential_jpg"
    t.text "resdential_webp"
    t.text "demonstration_zone_jpg"
    t.text "demonstration_zone_webp"
    t.text "mixed_used_tod_jpg"
    t.text "mixed_used_tod_webp"
    t.text "commercial_jpg"
    t.text "commercial_webp"
    t.text "supertall_jpg"
    t.text "supertall_webp"
    t.text "cultural_jpg"
    t.text "cultural_webp"
    t.text "education_jpg"
    t.text "education_webp"
    t.text "office_jpg"
    t.text "office_webp"
    t.text "urban_design_jpg"
    t.text "urban_design_webp"
    t.text "medical_care_jpg"
    t.text "medical_care_webp"
    t.text "hospitality_jpg"
    t.text "hospitality_webp"
    t.text "urban_planning_jpg"
    t.text "urban_planning_webp"
    t.text "landscape_jpg"
    t.text "landscape_webp"
    t.text "interior_jpg"
    t.text "interior_webp"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "cultural_wide_jpg"
    t.text "cultural_wide_webp"
  end

  create_table "works", id: :bigint, default: nil, force: :cascade do |t|
    t.date "design_completion"
    t.date "construction_completion"
    t.bigint "city_id", null: false
    t.bigint "site_area"
    t.decimal "planning_area"
    t.bigint "architecture_area"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "snapshot_jpg"
    t.text "snapshot_webp"
    t.boolean "published", default: true
    t.bigint "position"
    t.string "coordinate_lat"
    t.string "coordinate_lng"
    t.index ["city_id"], name: "index_works_on_city_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id", name: "active_storage_attachments_blob_id_fkey"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id", name: "active_storage_variant_records_blob_id_fkey"
  add_foreign_key "case_pictures", "cases", name: "case_pictures_case_id_fkey"
  add_foreign_key "pictures", "infos", name: "pictures_info_id_fkey"
  add_foreign_key "work_pictures", "works", name: "work_pictures_work_id_fkey"
  add_foreign_key "work_project_types", "project_types", name: "work_project_types_project_type_id_fkey"
  add_foreign_key "work_project_types", "works", name: "work_project_types_work_id_fkey"
  add_foreign_key "work_residential_types", "residential_types", name: "work_residential_types_residential_type_id_fkey"
  add_foreign_key "work_residential_types", "works", name: "work_residential_types_work_id_fkey"
  add_foreign_key "works", "cities", name: "works_city_id_fkey"
end
