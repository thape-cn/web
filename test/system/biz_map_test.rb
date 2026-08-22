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
end
