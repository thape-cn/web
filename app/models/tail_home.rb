# frozen_string_literal: true

class TailHome < ApplicationRecord
  has_one :hero_news, class_name: 'Info', foreign_key: :id, primary_key: :hero_news_id
  has_one :work_1, class_name: 'Work', foreign_key: :id, primary_key: :new_project_1_id
  has_one :work_2, class_name: 'Work', foreign_key: :id, primary_key: :new_project_2_id
  has_one :work_3, class_name: 'Work', foreign_key: :id, primary_key: :new_project_3_id
  has_one :work_4, class_name: 'Work', foreign_key: :id, primary_key: :new_project_4_id
  has_one :work_5, class_name: 'Work', foreign_key: :id, primary_key: :new_project_5_id
  has_one :work_6, class_name: 'Work', foreign_key: :id, primary_key: :new_project_6_id

  has_one :news_1, class_name: 'Info', foreign_key: :id, primary_key: :info_1_id
  has_one :news_2, class_name: 'Info', foreign_key: :id, primary_key: :info_2_id
  has_one :news_3, class_name: 'Info', foreign_key: :id, primary_key: :info_3_id

  mount_uploader :background_1, PictureUploader
  mount_uploader :background_1_webp, PictureUploader
  mount_uploader :background_2, PictureUploader
  mount_uploader :background_2_webp, PictureUploader
  mount_uploader :background_3, PictureUploader
  mount_uploader :background_3_webp, PictureUploader
  mount_uploader :background_4, PictureUploader
  mount_uploader :background_4_webp, PictureUploader
  mount_uploader :background_5, PictureUploader
  mount_uploader :background_5_webp, PictureUploader
  mount_uploader :background_6, PictureUploader
  mount_uploader :background_6_webp, PictureUploader

  mount_uploader :background_1_mobile, PictureUploader
  mount_uploader :background_1_mobile_webp, PictureUploader
  mount_uploader :background_2_mobile, PictureUploader
  mount_uploader :background_2_mobile_webp, PictureUploader
  mount_uploader :background_3_mobile, PictureUploader
  mount_uploader :background_3_mobile_webp, PictureUploader
  mount_uploader :background_4_mobile, PictureUploader
  mount_uploader :background_4_mobile_webp, PictureUploader
  mount_uploader :background_5_mobile, PictureUploader
  mount_uploader :background_5_mobile_webp, PictureUploader
  mount_uploader :background_6_mobile, PictureUploader
  mount_uploader :background_6_mobile_webp, PictureUploader

  mount_uploader :background_1_pad, PictureUploader
  mount_uploader :background_2_pad, PictureUploader
  mount_uploader :background_3_pad, PictureUploader
  mount_uploader :background_4_pad, PictureUploader
  mount_uploader :background_5_pad, PictureUploader
  mount_uploader :background_6_pad, PictureUploader

  mount_uploader :new_project_photo_1, PictureUploader
  mount_uploader :new_project_photo_2l, PictureUploader
  mount_uploader :new_project_photo_3w, PictureUploader
  mount_uploader :new_project_photo_4, PictureUploader
  mount_uploader :new_project_photo_5, PictureUploader
  mount_uploader :new_project_photo_6, PictureUploader

  mount_uploader :info_1_photo, PictureUploader
  mount_uploader :info_2_photo, PictureUploader
  mount_uploader :info_3_photo, PictureUploader

  mount_uploader :hero_news_photo, PictureUploader
  mount_uploader :hero_news_photo_mobile, PictureUploader
end
