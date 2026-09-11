# frozen_string_literal: true

class Admin::Home < ApplicationRecord
  self.table_name = "homes"
  include Admin::Uploads

  mount_uploader :banner_1, BannerUploader
  mount_uploader :banner_2, BannerUploader
  mount_uploader :banner_3, BannerUploader
  mount_uploader :banner_4, BannerUploader
  mount_uploader :banner_5, BannerUploader

  mount_uploader :banner_phone_1, BannerUploader
  mount_uploader :banner_phone_2, BannerUploader
  mount_uploader :banner_phone_3, BannerUploader
  mount_uploader :banner_phone_4, BannerUploader
  mount_uploader :banner_phone_5, BannerUploader

  mount_uploader :project_img_1, BannerUploader
  mount_uploader :project_img_2, BannerUploader
  mount_uploader :project_img_3, BannerUploader

  mount_uploader :project_phone_img_1, BannerUploader
  mount_uploader :project_phone_img_2, BannerUploader
  mount_uploader :project_phone_img_3, BannerUploader

  mount_uploader :info_img_1, BannerUploader
  mount_uploader :info_img_2, BannerUploader
  mount_uploader :info_img_3, BannerUploader

  mount_uploader :info_high_img, BannerUploader
  mount_uploader :info_high_phone_img, BannerUploader
  preserve_upload_paths
end
