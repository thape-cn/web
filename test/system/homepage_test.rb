# frozen_string_literal: true

require "application_system_test_case"

class HomepageTest < ApplicationSystemTestCase
  BLACK_HEADER_COLOR = /\Argba?\(16, 24, 32(?:, 1)?\)\z/

  test "header colors follow automatic and manual slide changes including wraparound" do
    tail_home_wallpapers(:wallpaper_1).update!(wall_paper_need_black_header: true)
    tail_home_wallpapers(:wallpaper_6).update!(wall_paper_need_black_header: true)
    visit root_path

    assert_selector "header.wallpaper-black-header", style: {color: BLACK_HEADER_COLOR}
    assert_selector ".thape-header .logo svg", style: {fill: BLACK_HEADER_COLOR}
    assert_selector ".menu-nav > .nav-item > a", minimum: 7, style: {color: BLACK_HEADER_COLOR}
    assert_selector ".menu-nav .nav-point", minimum: 6, style: {color: BLACK_HEADER_COLOR}
    assert_selector ".menu-nav .fonticon-rect", style: {stroke: BLACK_HEADER_COLOR}

    # Exercise the real five-second autoplay before pausing for manual controls.
    assert_selector ".image-item:nth-child(2).active:not(.animate)", wait: 8
    page.execute_script("document.querySelector('[data-controller=carousel2]').dataset.carousel2AutoPlayValue = 'false'")
    assert_no_selector "header.wallpaper-black-header"
    assert_selector "header.thape-header", style: {color: "rgba(255, 255, 255, 0.8)"}

    [["left", 1, true], ["left", 6, true], ["right", 1, true], ["right", 2, false]].each do |direction, slide, black|
      control = find(".thape-slide .action-#{direction}", visible: :all)
      control.hover
      control.click
      assert_selector ".image-item:nth-child(#{slide}).active:not(.animate)"
      assert_selector "header.thape-header#{black ? ".wallpaper-black-header" : ":not(.wallpaper-black-header)"}",
        style: {color: black ? BLACK_HEADER_COLOR : "rgba(255, 255, 255, 0.8)"}
    end
  end

  test "dark header includes mobile controls and remains readable with menus and scrolling" do
    tail_home_wallpapers(:wallpaper_1).update!(wall_paper_need_black_header: true)
    resize_viewport(390, 844)
    visit root_path
    page.execute_script("document.querySelector('[data-controller=carousel2]').dataset.carousel2AutoPlayValue = 'false'")
    assert_selector ".aside-menu-button", style: {color: BLACK_HEADER_COLOR}
    assert_selector '.thape-header button[data-action="click->header#showMobileSearch"] svg', style: {fill: BLACK_HEADER_COLOR}
    find(".aside-menu-button").click
    assert_selector ".aside-menu.show a", minimum: 1, style: {color: BLACK_HEADER_COLOR}
    assert_selector ".aside-menu-button svg", style: {stroke: BLACK_HEADER_COLOR}
    find(".aside-menu-button").click
    page.execute_script("window.scrollTo(0, 300)")
    assert_selector "header.active.wallpaper-black-header", style: {color: BLACK_HEADER_COLOR}
    page.execute_script("window.scrollTo(0, 0); document.activeElement.blur()")
    find(".thape-slide .action-right").click
    assert_selector ".image-item:nth-child(2).active:not(.animate)"
    assert_no_selector "header.wallpaper-black-header"
    assert_selector ".aside-menu-button", style: {color: "rgba(255, 255, 255, 0.8)"}
  end

  test "homepage presents its primary navigation and content" do
    visit root_path

    assert_current_path root_path

    within "header.thape-header" do
      assert_link "ABOUT", href: about_path
      assert_link "WORKS", href: works_path
      assert_link "SERVICE", href: building_path
      assert_link "NEWS", href: news_index_path
      assert_link "PUBLICATIONS", href: publications_path
      assert_link "CONTACT", href: biz_map_path
    end

    assert_selector ".thape-slide .image-item", count: 6, visible: :all
    assert_selector ".thape-slide img[alt='上一张']", visible: :all
    assert_selector ".thape-slide img[alt='下一张']", visible: :all

    within "#thape-new-projects" do
      assert_text "NEW PROJECTS"
      assert_link "MORE+", href: works_path
      assert_selector ".home-project-item", minimum: 6
    end

    within "#thape-home-news" do
      assert_text "NEWS"
      assert_link "MORE+", href: news_index_path
      assert_selector "a[href^='/news/']", count: 3
    end

    within "#thape-guest-form" do
      assert_text "CONTACT US"
      assert_field "guest-comment"
      assert_field "guest-name"
      assert_field "guest-company"
      assert_field "guest-contact"
      assert_button "Submit"
    end

    within "footer" do
      assert_link "CONTACT US", href: biz_map_path
      assert_text "© 2022 Tianhua Group，All Rights Reserved."
    end
  end
end
