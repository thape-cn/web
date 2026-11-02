# frozen_string_literal: true

require "test_helper"

class TailHomeTest < ActiveSupport::TestCase
  test "wallpapers default to a light header" do
    assert_equal false, TailHomeWallpaper.new.wall_paper_need_black_header
    assert_equal false, tail_home_wallpapers(:wallpaper_1).wall_paper_need_black_header
  end

  test "a homepage requires three through ten slides including pending changes" do
    [0, 2, 3, 6, 10, 11].each do |count|
      home = TailHome.new
      count.times { |index| home.wallpapers.build(position: index + 1) }
      assert_equal (3..10).cover?(count), home.valid?, "#{count} slides"
    end
    home = tail_homes(:tail_home_one)
    home.wallpapers.to_a.last(4).each(&:mark_for_destruction)
    assert_not home.valid?
    home.wallpapers.build(position: 7)
    assert home.valid?
    assert_equal [1, 2, 3], home.wallpapers.reject(&:marked_for_destruction?).map(&:position)
  end

  test "migrated uploads retain every original storage path after reordering" do
    wallpaper = tail_home_wallpapers(:wallpaper_1)
    TailHomeWallpaperUploader::LEGACY_SUFFIXES.each do |field, suffix|
      assert_equal "uploads/tail_home/background_1#{suffix}/1", wallpaper.public_send(field).store_dir
    end
    wallpaper.update!(position: 6)
    assert_equal "uploads/tail_home/background_1/1", wallpaper.image.store_dir
    new_slide = TailHomeWallpaper.new(id: 100, tail_home: tail_homes(:tail_home_one), position: 7)
    assert_equal "uploads/tail_home_wallpaper/image/100", new_slide.image.store_dir
  end
end
