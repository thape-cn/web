# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @original_wallpaper_upload_root = TailHomeWallpaperUploader.root
    @upload_root = Dir.mktmpdir("homepage-uploads")
    TailHomeWallpaperUploader.root = @upload_root
  end

  teardown do
    TailHomeWallpaperUploader.root = @original_wallpaper_upload_root
    FileUtils.remove_entry(@upload_root)
  end

  test "the current homepage renders TailHome content in both languages" do
    tail_home_wallpapers(:wallpaper_1).update!(title: "Current homepage banner")

    %i[cn en].each do |locale|
      get root_url, params: {locale: locale}
      assert_response :success
      assert_select ".slide-images p", text: "Current homepage banner", count: 1
    end
  end

  test "homepage renders the configured count and responsive image fallbacks" do
    home = tail_homes(:tail_home_one)
    home.wallpapers.to_a.last(3).each(&:mark_for_destruction)
    home.save!
    get root_url
    assert_response :success
    assert_select '.slide-images [data-type="slide-item"]', count: 3
    assert_select '.slide-images picture source[type="image/webp"]', count: 0
    assert_select '.slide-images picture source[media="(max-width: 768px)"]', count: 3
    assert_select '.slide-images picture img[src*="uploads/tail_home/background_1/1/"]', count: 1

    7.times { |index| home.wallpapers.build(position: index + 4, title: "Added #{index}") }
    home.save!
    get root_url
    assert_response :success
    assert_select '.slide-images [data-type="slide-item"]', count: 10
    assert_select '.slide-images [data-type="slide-item"].active', count: 1
    assert_select '.slide-images picture source[srcset=""]', count: 0
  end
end
