# frozen_string_literal: true

require "test_helper"

class CityTest < ActiveSupport::TestCase
  test "with_published_works only returns cities with a published work" do
    published_city = cities(:city_1)
    unpublished_city = City.create!(id: 100_001, name: "Unpublished", china_area_name: "华东", url_name: "unpublished")
    empty_city = City.create!(id: 100_002, name: "Empty", china_area_name: "华东", url_name: "empty")
    Work.unscoped.create!(id: 100_001, city: unpublished_city, published: false)

    cities = City.with_published_works

    assert_includes cities, published_city
    assert_not_includes cities, unpublished_city
    assert_not_includes cities, empty_city
  end
end
