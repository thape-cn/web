# frozen_string_literal: true

require "test_helper"

class WorksControllerTest < ActionDispatch::IntegrationTest
  test "residential category page uses maintainable images" do
    uploader = Struct.new(:url) do
      def present?
        true
      end
    end
    work_type_page = Struct.new(:residential_residence_jpg, :residential_community_jpg, :residential_rental_jpg).new(
      uploader.new("/uploads/residence.jpg"),
      uploader.new("/uploads/community.jpg"),
      uploader.new("/uploads/rental.jpg")
    )

    Seo.stub(:find_by, Seo.new) do
      WorkTypePage.stub(:first, work_type_page) do
        get residential_works_path
      end
    end

    assert_response :success
    assert_select 'img[src="/uploads/residence.jpg"]'
    assert_select 'img[src="/uploads/community.jpg"]'
    assert_select 'img[src="/uploads/rental.jpg"]'
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
end
