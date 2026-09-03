# frozen_string_literal: true

require "application_system_test_case"

class BizMapTest < ApplicationSystemTestCase
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
