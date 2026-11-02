# frozen_string_literal: true

require "test_helper"

class TailHomeWallpaperTest < ActiveSupport::TestCase
  test "every slide requires the desktop fallback even when alternative images exist" do
    wallpaper = TailHomeWallpaper.new(tail_home: tail_homes(:tail_home_one), position: 7)
    assert_not wallpaper.valid?
    assert wallpaper.errors[:image].present?

    %i[mobile_image image_webp mobile_image_webp tablet_image tablet_image_webp].each do |field|
      wallpaper.public_send(field).retrieve_from_store!("alternative.jpg")
    end
    assert_not wallpaper.valid?
    assert wallpaper.errors[:image].present?

    wallpaper.image.retrieve_from_store!("desktop.jpg")
    assert wallpaper.valid?
  end

  test "removing the required desktop image is invalid but optional images may be removed" do
    wallpaper = tail_home_wallpapers(:wallpaper_1)
    wallpaper.remove_mobile_image = "1"
    wallpaper.remove_image_webp = "1"
    assert wallpaper.valid?

    wallpaper.remove_image = "1"
    assert_not wallpaper.valid?
    assert wallpaper.errors[:image].present?
  end
end
