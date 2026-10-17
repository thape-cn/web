# frozen_string_literal: true

class Picture < ApplicationRecord
  belongs_to :info, required: false
  has_many :picture_references, dependent: :delete_all
  has_many :referenced_infos, -> { distinct }, through: :picture_references, source: :owner, source_type: "Info"

  validates :image, presence: true
  mount_uploader :image, PictureUploader

  after_update :refresh_picture_references, if: :saved_change_to_image?

  private

  def refresh_picture_references
    picture_references.includes(:owner).map(&:owner).compact.uniq.each do |owner|
      PictureReference.sync_for(owner)
    end
  end
end
