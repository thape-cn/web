# frozen_string_literal: true

class Admin::Work < ::Work
  include Admin::Uploads

  has_many :work_pictures, class_name: "::WorkPicture", foreign_key: :work_id, inverse_of: :work, dependent: :destroy
  accepts_nested_attributes_for :work_pictures, allow_destroy: true,
    reject_if: ->(attributes) { attributes.except("id", "_destroy").values.all?(&:blank?) }
  preserve_upload_paths
end
