class TailHome < ApplicationRecord
  mount_uploader :new_project_photo_1, PictureUploader
  mount_uploader :new_project_photo_2l, PictureUploader
  mount_uploader :new_project_photo_3w, PictureUploader
  mount_uploader :new_project_photo_4, PictureUploader
  mount_uploader :new_project_photo_5, PictureUploader
  mount_uploader :new_project_photo_6, PictureUploader

  mount_uploader :hero_news_photo, PictureUploader

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
end
