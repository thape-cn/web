class AboutPage < ApplicationRecord
  translates :thape_intro

  mount_uploader :about_h1, PictureUploader
  mount_uploader :about_h1_mobile, PictureUploader
  mount_uploader :about_h2, PictureUploader
  mount_uploader :about_h2_mobile, PictureUploader
  mount_uploader :about_h3, PictureUploader
  mount_uploader :about_h3_mobile, PictureUploader
  mount_uploader :about_h4, PictureUploader
  mount_uploader :about_h4_mobile, PictureUploader
  mount_uploader :about_h5, PictureUploader
  mount_uploader :about_h5_mobile, PictureUploader
  mount_uploader :about_h6, PictureUploader
  mount_uploader :about_h6_mobile, PictureUploader
  mount_uploader :about_h7, PictureUploader
  mount_uploader :about_h7_mobile, PictureUploader
end
