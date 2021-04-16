# frozen_string_literal: true

class Publication < ApplicationRecord
  translates :title, :sub_title
  mount_uploader :pdf_file, PdfFileUploader
  mount_uploader :cover_jpg, JpgPngUploader
  mount_uploader :cover_webp, WebpUploader
  mount_uploader :mobile_cover_jpg, JpgPngUploader
  mount_uploader :mobile_cover_webp, WebpUploader
  enum category_status: %i[monographs standard_specification paper_patent]
end
