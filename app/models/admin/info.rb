# frozen_string_literal: true

class Admin::Info < ::Info
  include Admin::Uploads

  mount_uploader :pdf_file, PdfFileUploader
  preserve_upload_paths
end
