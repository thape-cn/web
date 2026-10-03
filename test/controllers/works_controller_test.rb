# frozen_string_literal: true

require "test_helper"

class WorksControllerTest < ActionDispatch::IntegrationTest
  test "residential category page uses maintainable images" do
    get_residential_page(residential_images(jpg: true))

    assert_response :success
    %w[residence community rental].each do |category|
      assert_select "picture img[src='/uploads/#{category}.jpg']"
    end
    assert_select 'picture source[type="image/webp"]', count: 0
  end

  test "residential category page offers WebP images with uploaded JPEG fallbacks" do
    get_residential_page(residential_images(jpg: true, webp: true))

    assert_response :success
    %w[residence community rental].each do |category|
      assert_select "picture" do |pictures|
        picture = pictures.find { |node| node.at_css("img[src='/uploads/#{category}.jpg']") }
        assert picture
        assert_select picture, "source[type='image/webp'][srcset='/uploads/#{category}.webp']"
      end
    end
  end

  test "residential category page offers WebP images with default JPEG fallbacks" do
    get_residential_page(residential_images(webp: true))

    assert_response :success
    %w[residence community rental].each_with_index do |category, index|
      assert_select "picture" do |pictures|
        picture = pictures.find { |node| node.at_css("source[srcset='/uploads/#{category}.webp']") }
        assert picture
        assert_select picture, "img[src*='residential-#{index + 1}']"
      end
    end
  end

  test "residential category page keeps default images when uploads are absent" do
    [nil, WorkTypePage.new].each do |page|
      get_residential_page(page)

      assert_response :success
      assert_select 'picture source[type="image/webp"]', count: 0
      (1..3).each { |index| assert_select "picture img[src*='residential-#{index}']" }
    end
  end

  test "project type and city filters are retained and applied together" do
    Seo.stub(:find_by, Seo.new) do
      get demonstration_zone_works_path, params: {city: "suzhou"}
    end

    assert_response :success
    assert_select "button", text: /展示区\/示范区/
    assert_select "button", text: /苏州/
    assert_select "input[type=hidden][name=city][value=suzhou]"
    assert_select "a[href=?]", demonstration_zone_works_path(city: "suzhou")
    assert_select "a[href=?]", cultural_works_path(city: "suzhou")
    assert_select "a[href=?]", demonstration_zone_works_path, text: "重置"
    assert_select ".flex-grid a", count: 0
  end

  test "choosing a project type from a city page retains the city" do
    get work_path(id: "jinan")

    assert_response :success
    assert_select "a[href=?]", demonstration_zone_works_path(city: "jinan")
  end

  private

  def residential_images(jpg: false, webp: false)
    fields = %i[residential_residence_jpg residential_residence_webp residential_community_jpg residential_community_webp residential_rental_jpg residential_rental_webp]
    page = Struct.new(*fields).new
    uploader = Struct.new(:url)
    %w[residence community rental].each do |category|
      page["residential_#{category}_jpg"] = uploader.new("/uploads/#{category}.jpg") if jpg
      page["residential_#{category}_webp"] = uploader.new("/uploads/#{category}.webp") if webp
    end
    page
  end

  def get_residential_page(page)
    Seo.stub(:find_by, Seo.new) do
      WorkTypePage.stub(:first, page) { get residential_works_path }
    end
  end
end
