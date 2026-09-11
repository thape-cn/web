# frozen_string_literal: true

class Admin::CasePicture < ApplicationRecord
  self.table_name = "case_pictures"
  include Admin::Uploads

  belongs_to :case, class_name: "Admin::Case", inverse_of: :case_pictures
  mount_uploader :album, PictureUploader
  preserve_upload_paths
end
