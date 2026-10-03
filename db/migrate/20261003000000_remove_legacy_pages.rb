# frozen_string_literal: true

class RemoveLegacyPages < ActiveRecord::Migration[7.2]
  def change
    # Reversal recreates empty tables; restoring content requires a backup.
    drop_table :about_translations, id: :bigint, default: nil do |t|
      t.bigint :about_id, null: false
      t.text :locale, null: false
      t.datetime :created_at, precision: nil, null: false
      t.datetime :updated_at, precision: nil, null: false
      t.text :about_title
      t.text :about_content
      t.text :about_img_alt
      t.index :about_id
      t.index :locale
    end

    drop_table :abouts, id: :bigint, default: nil do |t|
      t.text :about_title
      t.text :about_content
      t.text :about_img
      t.text :about_img_alt
      t.datetime :created_at, precision: nil, null: false
      t.datetime :updated_at, precision: nil, null: false
    end

    drop_table :homes, id: :bigint, default: nil do |t|
      t.text :banner_1
      t.text :title_1
      t.text :subtitle_1
      t.text :banner_2
      t.text :title_2
      t.text :subtitle_2
      t.text :banner_3
      t.text :title_3
      t.text :subtitle_3
      t.text :banner_4
      t.text :title_4
      t.text :subtitle_4
      t.text :banner_5
      t.text :title_5
      t.text :subtitle_5
      t.text :project_img_1
      t.text :project_title_1
      t.text :project_subtitle_1
      t.text :project_link_1
      t.text :project_img_2
      t.text :project_title_2
      t.text :project_subtitle_2
      t.text :project_link_2
      t.text :project_img_3
      t.text :project_title_3
      t.text :project_subtitle_3
      t.text :project_link_3
      t.text :info_img_1
      t.text :info_title_1
      t.text :info_subtitle_1
      t.text :info_link_1
      t.text :info_img_2
      t.text :info_title_2
      t.text :info_subtitle_2
      t.text :info_link_2
      t.text :info_img_3
      t.text :info_title_3
      t.text :info_subtitle_3
      t.text :info_link_3
      t.datetime :created_at, precision: nil, null: false
      t.datetime :updated_at, precision: nil, null: false
      t.text :banner_phone_1
      t.text :banner_phone_2
      t.text :banner_phone_3
      t.text :banner_phone_4
      t.text :banner_phone_5
      t.text :project_phone_img_1
      t.text :project_phone_img_2
      t.text :project_phone_img_3
      t.text :banner_alt_1
      t.text :banner_alt_2
      t.text :banner_alt_3
      t.text :banner_alt_4
      t.text :banner_alt_5
      t.text :project_alt_1
      t.text :project_alt_2
      t.text :project_alt_3
      t.text :info_alt_1
      t.text :info_alt_2
      t.text :info_alt_3
      t.text :info_high_img
      t.text :info_high_title
      t.text :info_high_introduction
      t.text :info_high_link
      t.text :info_high_phone_img
    end
  end
end
