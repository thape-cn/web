# frozen_string_literal: true

require "application_system_test_case"

class FrontendInteractionsTest < ApplicationSystemTestCase
  setup do
    resize_viewport(1400, 1000)
  end

  test "work filters toggle, dismiss and navigate to a city" do
    visit works_path(q: "test", locale: :en)
    menus = all("[data-controller='dropdown']")
    project_menu, city_menu = menus
    assert_no_selector "[data-dropdown-target='panel']"

    project_menu.find("button").click
    assert_selector "[data-dropdown-target='panel']", count: 1
    assert_link "RESIDENTIAL"
    city_menu.find("button").click
    project_menu.assert_no_selector "[data-dropdown-target='panel']"
    assert_selector "[data-dropdown-target='panel']", count: 1
    city_menu.find("button").send_keys(:escape)
    assert_no_selector "[data-dropdown-target='panel']"

    project_menu.find("button").click
    find("input[name='q']").click
    assert_no_selector "[data-dropdown-target='panel']"
    city_menu.find("button").click
    city_menu.click_link "SHANGHAI"
    assert_current_path work_path(id: "shanghai"), ignore_query: true
    assert_button "SHANGHAI"
  end

  test "leadership search buttons submit and branch menu navigates" do
    person = Person.create!(id: 9001, url_name: "test-architect", category: 1)
    person.translations.create!(id: 9001, locale: :en, name: "Test Architect", title: "Architect")
    CityPerson.create!(id: 9001, person: person, city: cities(:city_1))
    CityPerson.create!(id: 9002, person: person, city: cities(:city_18))

    visit leadership_index_path(locale: :en)
    within "#leadership-form" do
      find("input[name='name']").set("Architect")
      find("button[type='submit']").click
    end
    assert_current_path leadership_index_path(name: "Architect")

    visit leadership_path(id: "shanghai", locale: :en)
    within "#area-leadership-form" do
      click_button "SHANGHAI"
      assert_link "CHONGQIN"
      click_button "SHANGHAI"
      assert_no_link "CHONGQIN"
      click_button "SHANGHAI"
      click_link "CHONGQIN"
    end
    assert_current_path leadership_path(id: "chongqin"), ignore_query: true
    within "#area-leadership-form" do
      find("input[name='name']").set("Architect")
      find("button[type='submit']").click
    end
    assert_current_path leadership_path(id: "chongqin", name: "Architect")
  end

  test "publication categories stay synchronized between desktop and mobile tabs" do
    I18n.with_locale(:en) do
      Publication.category_statuses.each_key do |category|
        3.times { |index| Publication.create!(category_status: category, title: "Test #{category} #{index}") }
      end
    end
    visit publications_path(locale: :en)
    assert_text "Test monographs"
    assert_no_text "Test standard_specification"
    origin = find("[data-publications-target='categoryOrigin']")
    origin.find("[data-category='standard_specification']").click
    assert_text "Test standard_specification"
    assert_no_text "Test monographs"
    assert_selector "[data-publications-target='category'][data-category='standard_specification'][aria-pressed='true']", count: 2, visible: :all

    resize_viewport(390, 844)
    page.scroll_to(find("footer"))
    fixed = find("[data-publications-target='categoryFixed']")
    fixed.find("[data-category='paper_patent']").click
    assert_text "Test paper_patent"
    assert_no_text "Test standard_specification"
    assert_selector "[data-publications-target='category'][data-category='paper_patent'][aria-pressed='true']", count: 2, visible: :all

    resize_viewport(1400, 1000)
    assert_no_selector "[data-publications-target='categoryFixed']"
    assert_text "Test paper_patent"
  end

  test "culture slideshow advances, selects the fifth slide and loops" do
    visit culture_path(locale: :en)
    assert_selector "[data-culture-target='slide'][aria-hidden='false'][alt$='1']"
    assert_selector "[data-culture-target='slide'][aria-hidden='false'][alt$='2']", wait: 7
    find("[data-culture-target='dot'][data-slide='4']").click
    assert_selector "[data-culture-target='slide'][aria-hidden='false'][alt$='5']"
    assert_selector "[data-culture-target='dot'][data-slide='4'][aria-pressed='true']"
    assert_selector "[data-culture-target='slide'][aria-hidden='false'][alt$='1']", wait: 8
    resize_viewport(390, 844)
    width = find("[data-culture-target='sliders']").rect.width
    assert_operator width, :<=, 390
  end

  test "news cards and footer QR codes reveal on hover and keyboard focus" do
    visit root_path(locale: :en)
    card = first(".news-card")
    within(card) { assert_no_selector ".hover-card-panel" }
    card.hover
    within(card) { assert_selector ".hover-card-panel" }
    assert_equal "blur(2px)", card.find("img").evaluate_script("getComputedStyle(this).filter")
    find("#thape-home-news").find_link("MORE+").hover
    within(card) { assert_no_selector ".hover-card-panel" }

    %w[wechat shipinhao xiaohongshu].each do |network|
      qr = find("##{network}-qr", visible: :all)
      button = find("button[aria-describedby='#{network}-qr']")
      button.hover
      assert qr.visible?
      button.send_keys(:space)
      find("footer nav").hover
      assert qr.visible?, "QR remains visible while its button has keyboard focus"
      button.send_keys(:tab)
      assert_no_selector "##{network}-qr"
    end
  end

  test "about cards show details on hover and focus" do
    about = I18n.with_locale(:en) { AboutPage.new(thape_intro: "About test") }
    AboutPage.stub(:first, about) { visit about_path(locale: :en) }
    card = first(".about-card")
    within(card) { assert_selector ".hover-card-title" }
    within(card) { assert_no_selector ".hover-card-panel" }
    card.hover
    within(card) { assert_selector ".hover-card-panel" }
    within(card) { assert_no_selector ".hover-card-title" }
    card.send_keys(:space)
    find("footer").hover
    within(card) { assert_selector ".hover-card-panel" }
    card.send_keys(:tab)
    within(card) { assert_no_selector ".hover-card-panel" }
  end
end
