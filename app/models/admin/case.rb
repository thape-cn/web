# frozen_string_literal: true

class Admin::Case < ApplicationRecord
  self.table_name = "cases"
  include Admin::Uploads

  has_many :case_pictures, class_name: "Admin::CasePicture", foreign_key: :case_id, inverse_of: :case, dependent: :destroy
  accepts_nested_attributes_for :case_pictures, allow_destroy: true,
    reject_if: ->(attributes) { attributes.except("id", "_destroy").values.all?(&:blank?) }
  mount_uploader :snapshot, SnapshotUploader

  def self.professional_options
    [["建筑", 1], ["规划", 2], ["室内", 3], ["景观", 4]].freeze
  end

  def self.market_options
    [["居住建筑", 1], ["商业建筑", 2], ["办公建筑", 3], ["文教体卫", 4], ["城市更新", 5], ["旅游度假", 6]].freeze
  end
  preserve_upload_paths
end
