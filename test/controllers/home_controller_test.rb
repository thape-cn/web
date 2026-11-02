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

    7.times do |index|
      home.wallpapers.build(position: index + 4, title: "Added #{index}")[:image] = "desktop.jpg"
    end
    home.save!
    get root_url
    assert_response :success
    assert_select '.slide-images [data-type="slide-item"]', count: 10
    assert_select '.slide-images [data-type="slide-item"].active', count: 1
    assert_select '.slide-images picture source[srcset=""]', count: 0
  end

  test "homepage carousel and search controls have localized accessible names before JavaScript" do
    tail_home_wallpapers(:wallpaper_1).update!(title: "Featured project", link: "/works/1")
    tail_home_wallpapers(:wallpaper_2).update!(title: "", subtitle: "", link: "/works/2")
    tail_home_wallpapers(:wallpaper_3).update!(title: "No link", link: "")
    %i[cn en].each do |locale|
      get root_url, params: {locale: locale}
      assert_response :success
      assert_select '.home-carousel[role="region"][aria-label=?]', I18n.t("home_carousel.label", locale: locale)
      %w[previous next].each do |control|
        assert_select '.home-carousel button[type="button"][aria-label=?]', I18n.t("work_carousel.#{control}", locale: locale)
      end
      assert_select '[data-home-carousel-target="pauseLabel"]', text: I18n.t("work_carousel.pause", locale: locale)
      assert_select '.home-carousel .image-item[aria-hidden="true"][inert]', count: 5
      assert_select '.home-carousel .image-item[aria-hidden="false"]:not([inert])', count: 1
      assert_select '.home-carousel a[href="/works/1"][aria-label=?]', I18n.t("home_carousel.open_link", title: "Featured project", locale: locale)
      assert_select '.home-carousel a[href="/works/2"][aria-label=?]', I18n.t("home_carousel.open_link", title: I18n.t("home_carousel.untitled", number: 2, locale: locale), locale: locale)
      assert_select ".home-carousel .image-item:nth-child(3) a", count: 0
      assert_select '.home-carousel .image-item:nth-child(3) img[alt="No link"]'
      assert_select 'button[data-action="click->header#showMobileSearch"][aria-label=?]', I18n.t("ui.keyword_search", locale: locale)
      assert_select 'button[data-header-target="formSubmit"][aria-label=?]', I18n.t("ui.keyword_search", locale: locale)
    end
  end

  test "homepage renders each header preference and applies the first slide before JavaScript" do
    tail_home_wallpapers(:wallpaper_2).update!(wall_paper_need_black_header: true)
    get root_url
    assert_select "header.thape-header.wallpaper-black-header", count: 0
    assert_select '.slide-images [data-wall-paper-need-black-header="false"]', count: 5
    assert_select '.slide-images [data-wall-paper-need-black-header="true"]', count: 1

    tail_home_wallpapers(:wallpaper_1).update!(wall_paper_need_black_header: true)
    %i[cn en].each do |locale|
      get root_url, params: {locale: locale}
      assert_response :success
      assert_select "header.thape-header.wallpaper-black-header", count: 1
      assert_select '.slide-images .active[data-wall-paper-need-black-header="true"]', count: 1
    end
  end
end
