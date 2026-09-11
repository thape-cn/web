# frozen_string_literal: true

class Admin::About < ApplicationRecord
  self.table_name = "abouts"
  include Admin::Uploads

  translates :about_title, :about_content, :about_img_alt

  mount_uploader :about_img, BannerUploader
  preserve_upload_paths
end
