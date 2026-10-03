# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "the current homepage renders TailHome content in both languages" do
    tail_homes(:tail_home_one).update!(background_1_title: "Current homepage banner")

    %i[cn en].each do |locale|
      get root_url, params: {locale: locale}
      assert_response :success
      assert_select ".slide-images p", text: "Current homepage banner", count: 1
    end
  end
end
