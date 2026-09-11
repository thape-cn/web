# frozen_string_literal: true

class Admin::ServiceFile < ::ServiceFile
  include Admin::Uploads

  mount_uploader :tianhua_2020_bill_music, ServiceFileUploader
  preserve_upload_paths
end
