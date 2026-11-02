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
    page.execute_script("#{carousel_controller}.stopAutoPlay()")
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
    page.execute_script("#{carousel_controller}.stopAutoPlay()")
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
    assert_selector ".thape-slide button.action-left[aria-label]", visible: :all
    assert_selector ".thape-slide button.action-right[aria-label]", visible: :all

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

  test "homepage controls support Tab Enter Space and keep inactive links out of focus" do
    tail_home_wallpapers(:wallpaper_1).update!(title: "First project", link: "/works/1")
    tail_home_wallpapers(:wallpaper_2).update!(title: "Second project", link: "/works/2")
    visit root_path(locale: :en)
    assert_no_selector ".home-carousel .work-carousel-rotation"
    find('.home-carousel-link[href="/works/1"]').send_keys(:tab)
    assert_selector ".home-carousel .action-left:focus"
    assert_no_selector ".home-carousel .work-carousel-rotation"
    assert_not carousel_running?
    previous = find(".home-carousel .action-left")
    assert_equal "1", previous.evaluate_script("getComputedStyle(this).opacity")
    assert_operator previous.evaluate_script("parseFloat(getComputedStyle(this).outlineWidth)"), :>, 0
    previous.send_keys(:enter)
    assert_selector ".home-carousel .image-item:nth-child(6).active:not(.animate)"
    assert_selector ".home-carousel .work-carousel-rotation", text: "Play slideshow"
    previous.send_keys(:tab)
    assert_selector ".home-carousel .action-right:focus"
    following = find(".home-carousel .action-right")
    following.send_keys(:space)
    assert_selector ".home-carousel .image-item:nth-child(1).active:not(.animate)"
    following.send_keys(:enter)
    assert_selector ".home-carousel .image-item:nth-child(2).active:not(.animate)"
    assert_selector '.home-carousel .image-item[inert][aria-hidden="true"]', count: 5, visible: :all
    following.send_keys([:shift, :tab])
    previous.send_keys([:shift, :tab])
    assert_selector '.home-carousel-link[href="/works/2"]:focus'
    assert_selector '[data-home-carousel-target="status"][aria-live="polite"]', text: "2 / 6"
    find(".home-carousel-link:focus").send_keys([:shift, :tab])
    assert_selector ".home-carousel .work-carousel-rotation:focus"
    find(".home-carousel .work-carousel-rotation").send_keys(:enter)
    assert_no_selector ".home-carousel .work-carousel-rotation"
    assert_selector ".home-carousel .action-right:focus"
    assert carousel_running?
    page.save_screenshot(Rails.root.join("tmp/home-carousel-desktop.png")) # standard:disable Lint/Debugger
  end

  test "homepage reveals play only after arrow clicks and resumes immediately when play is clicked" do
    visit root_path(locale: :en)
    find(".thape-header .logo").hover
    assert carousel_running?
    assert_no_selector ".home-carousel .work-carousel-rotation"
    assert_carousel_controls_at_corner
    find('.home-carousel button[aria-label="Next image"]', visible: :all).hover.click
    assert_selector ".home-carousel .image-item:nth-child(2).active:not(.animate)"
    find(".thape-header .logo").hover
    assert_selector '[data-home-carousel-target="playLabel"]:not([hidden])', text: "Play slideshow"
    assert_not carousel_running?
    assert_carousel_controls_at_corner

    page.scroll_to(find("#thape-new-projects"))
    assert_selector "header.active"
    assert page.evaluate_script("#{carousel_controller}.suspended")
    page.execute_script("window.scrollTo(0, 0)")
    assert_no_selector "header.active"
    assert_not page.evaluate_script("#{carousel_controller}.suspended")
    assert_not carousel_running?
    click_button "Play slideshow"
    assert_no_selector ".home-carousel .work-carousel-rotation"
    assert_carousel_controls_at_corner
    assert carousel_running?
    assert_selector ".home-carousel .image-item:nth-child(3).active:not(.animate)", wait: 8
    find('.home-carousel button[aria-label="Previous image"]', visible: :all).hover.click
    assert_selector ".home-carousel .work-carousel-rotation", text: "Play slideshow"
    assert_not carousel_running?
  end

  test "homepage respects reduced motion and exposes named mobile controls" do
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [{name: "prefers-reduced-motion", value: "reduce"}])
    resize_viewport(390, 844)
    visit root_path(locale: :en)
    assert_no_selector ".home-carousel .work-carousel-rotation"
    assert_not carousel_running?
    assert_selector 'button[data-action="click->header#showMobileSearch"][aria-label="Keyword search"]'
    find('button[aria-label="Next image"]').click
    assert_selector ".home-carousel .image-item:nth-child(2).active:not(.animate)"
    assert_no_selector ".home-carousel .animate"
    assert_selector ".home-carousel .work-carousel-rotation", text: "Play slideshow"
    assert_carousel_controls_at_corner
    assert_operator find(".home-carousel .action-right").rect.width, :>=, 44
    assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
    page.save_screenshot(Rails.root.join("tmp/home-carousel-mobile.png")) # standard:disable Lint/Debugger
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [{name: "prefers-reduced-motion", value: "no-preference"}])
    assert_not carousel_running?
    click_button "Play slideshow"
    assert_no_selector ".home-carousel .work-carousel-rotation"
    assert_carousel_controls_at_corner
    assert carousel_running?
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [{name: "prefers-reduced-motion", value: "reduce"}])
    assert_selector '[data-home-carousel-target="status"][aria-live="polite"]'
    assert_no_selector ".home-carousel .work-carousel-rotation"
    assert_not carousel_running?
  ensure
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [])
  end

  private

  def assert_carousel_controls_at_corner
    rect = find(".home-carousel .work-carousel-controls").evaluate_script("this.getBoundingClientRect().toJSON()")
    assert_in_delta page.evaluate_script("document.documentElement.clientWidth"), rect["right"], 1
    assert_in_delta page.evaluate_script("innerHeight"), rect["bottom"], 1
  end

  def carousel_controller
    "window.web_app.getControllerForElementAndIdentifier(document.querySelector('.home-carousel'), 'home-carousel')"
  end

  def carousel_running?
    page.evaluate_script("!!#{carousel_controller}.timer")
  end
end
