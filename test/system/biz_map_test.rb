# frozen_string_literal: true

require "application_system_test_case"

class BizMapTest < ApplicationSystemTestCase
  test "company selection updates the map and city selection clears the company" do
    page.current_window.resize_to(1400, 1000)
    contact = I18n.with_locale(:en) { MapContact.new(long_name: "Test office") }
    MapContact.stub(:find, contact) { visit biz_map_path(locale: :en) }
    assert_no_selector "[data-biz-map-target='companyPanel']"
    assert_no_selector "[data-biz-map-target='cityPanel']"

    find("[data-biz-map-target='company'][data-company='上海天华']").click
    assert_selector "[data-biz-map-target='companyPanel'][data-company='上海天华']", count: 1
    assert_selector "[data-biz-map-target='marker'][data-city='上海'].map-star-b"
    assert_selector "[data-biz-map-target='city'][data-city='上海'][aria-pressed='true']"
    assert_selector "[data-biz-map-target='cityPanel'][data-city='上海']"

    find("[data-biz-map-target='city'][data-city='北京']").send_keys(:enter)
    assert_no_selector "[data-biz-map-target='companyPanel']"
    assert_no_selector "[data-biz-map-target='cityPanel'][data-city='上海']"
    assert_selector "[data-biz-map-target='cityPanel'][data-city='北京']", text: "Test office"
    assert_selector "[data-biz-map-target='marker'][data-city='上海'].map-dot-b"

    find("#under-map-companies [data-company='虹核审图']").click
    assert_selector "[data-biz-map-target='companyPanel'][data-company='虹核审图']", count: 1
    assert_selector "[data-biz-map-target='company'][data-company='虹核审图'].bg-gray-100"
    map = find("img[data-action='click->biz-map#reset']")
    page.scroll_to(map, align: :center)
    map.click
    assert_no_selector "[data-biz-map-target='companyPanel']"
    assert_no_selector "[data-biz-map-target='cityPanel']"
    assert_no_selector ".map-star-b"
  end

  test "mobile company cards open a contact overlay that dismisses on tap" do
    resize_viewport(390, 844)
    MapContact.stub(:find, MapContact.new) { visit biz_map_path(locale: :en) }
    find("[data-biz-map-target='company'][data-company='上海天华']").click
    panel = find("[data-biz-map-target='companyPanel'][data-company='上海天华']")
    assert_equal "fixed", panel.evaluate_script("getComputedStyle(this).position")
    assert_text "021-34189900"
    panel.click(x: 5, y: 5, offset: :top_left)
    assert_no_selector "[data-biz-map-target='companyPanel']"
    assert_selector "[data-biz-map-target='cityPanel'][data-city='上海']"
  end

  test "company cards use the compact desktop layout" do
    page.current_window.resize_to(1268, 854)

    MapContact.stub(:find, MapContact.new) do
      visit biz_map_path
    end

    upper_company = find("div", text: "上海天华", exact_text: true)
    lower_company = find("#under-map-companies > div", text: "上海虹核审图", exact_text: true)

    upper_width = upper_company.evaluate_script("this.getBoundingClientRect().width")
    lower_width = lower_company.evaluate_script("this.getBoundingClientRect().width")
    upper_padding_top = upper_company.evaluate_script("getComputedStyle(this).paddingTop")
    lower_padding_top = lower_company.evaluate_script("getComputedStyle(this).paddingTop")
    upper_justification = upper_company.evaluate_script("getComputedStyle(this).justifyContent")
    lower_justification = lower_company.evaluate_script("getComputedStyle(this).justifyContent")

    assert_operator lower_width, :<, upper_width
    assert_equal upper_padding_top, lower_padding_top
    assert_equal upper_justification, lower_justification
  end

  test "phone numbers in a map contact card share the same left edge" do
    page.current_window.resize_to(1400, 1000)

    MapContact.stub(:find, MapContact.new) do
      visit biz_map_path
    end

    find("div", text: "上海天华", exact_text: true).click
    phone_numbers = all(".map-contact-tels p", visible: true)

    assert_equal 2, phone_numbers.size
    assert_in_delta phone_numbers.first.rect.x, phone_numbers[1].rect.x, 0.1
  end
end
