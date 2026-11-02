# frozen_string_literal: true

class TailHomeWallpaperUploader < PictureUploader
  LEGACY_SUFFIXES = {
    image: "", image_webp: "_webp", mobile_image: "_mobile",
    mobile_image_webp: "_mobile_webp", tablet_image: "_pad", tablet_image_webp: "_pad_webp"
  }.freeze

  def store_dir
    return super unless model.legacy_slot

    "uploads/tail_home/background_#{model.legacy_slot}#{LEGACY_SUFFIXES.fetch(mounted_as)}/#{model.tail_home_id}"
  end
end
