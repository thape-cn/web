class TailHome < ApplicationRecord
  mount_uploader :new_project_photo_1, PictureUploader
  mount_uploader :new_project_photo_2l, PictureUploader
  mount_uploader :new_project_photo_3w, PictureUploader
  mount_uploader :new_project_photo_4, PictureUploader
  mount_uploader :new_project_photo_5, PictureUploader
  mount_uploader :new_project_photo_6, PictureUploader

  mount_uploader :hero_news_photo, PictureUploader

  has_one :hero_news, class_name: 'Info', foreign_key: :id, primary_key: :hero_news_id
end
