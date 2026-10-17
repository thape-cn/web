# frozen_string_literal: true

module ReferencesPictures
  extend ActiveSupport::Concern

  included do
    has_many :picture_references, as: :owner, dependent: :delete_all
    has_many :embedded_pictures, -> { distinct }, through: :picture_references, source: :picture
    after_save :sync_picture_references
  end

  private

  def sync_picture_references
    PictureReference.sync_for(self)
  end
end
