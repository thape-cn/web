# frozen_string_literal: true

class TailHomeWallpaper < ApplicationRecord
  IMAGE_FIELDS = %i[image image_webp mobile_image mobile_image_webp tablet_image tablet_image_webp].freeze

  belongs_to :tail_home, inverse_of: :wallpapers
  IMAGE_FIELDS.each { |field| mount_uploader field, TailHomeWallpaperUploader }

  validates :position, numericality: {only_integer: true, in: 1..10}
  validate :desktop_image_present
  attr_readonly :legacy_slot, :tail_home_id

  private

  def desktop_image_present
    return if image.identifier.present? && !remove_image?

    errors.add(:image, I18n.t("admin.home_wallpaper.image_required"))
  end
end
