# frozen_string_literal: true

require "application_system_test_case"

class HomepageTest < ApplicationSystemTestCase
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
