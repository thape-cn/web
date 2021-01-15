# frozen_string_literal: true

class Picture < ApplicationRecord
  belongs_to :info, required: false

  validates :image, presence: true
  mount_uploader :image, PictureUploader
end
