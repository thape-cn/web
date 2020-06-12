class WorkPicture < ApplicationRecord
  belongs_to :work
  mount_uploader :album_jpg, JpgUploader
  mount_uploader :album_webp, WebpUploader
end
