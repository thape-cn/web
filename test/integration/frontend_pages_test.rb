# frozen_string_literal: true

require "test_helper"

class FrontendPagesTest < ActionDispatch::IntegrationTest
  test "interactive pages render without loading Alpine or leaving directives behind" do
    about = I18n.with_locale(:en) { AboutPage.new(thape_intro: "About test") }
    I18n.with_locale(:en) { Publication.create!(title: "Test publication") }

    AboutPage.stub(:first, about) do
      MapContact.stub(:find, MapContact.new) do
        [root_path, about_path, culture_path, works_path(q: "test"),
          leadership_index_path, leadership_path(id: "shanghai"), publications_path, biz_map_path].each do |path|
          get path, params: {locale: :en}
          assert_response :success
          assert_select "script[src*='application']", minimum: 1
          assert_select "script[src*='alpine']", count: 0
          assert_empty Nokogiri::HTML(response.body).xpath("//@*[starts-with(name(), 'x-')]")
        end
      end
    end
  end

  test "contact panels are hidden before JavaScript starts and selection placeholders are rendered" do
    MapContact.stub(:find, MapContact.new) { get biz_map_path, params: {locale: :en} }
    assert_response :success
    assert_select "#project-message-dialog[hidden]"
    assert_select "#project-message-project_type-options[hidden]"
    assert_select "#project-message-service_type-options[hidden]"
    assert_select "#project-message-project_type-button", text: I18n.t("project_message_form.project_type_placeholder", locale: :en)
    assert_select "#project-message-service_type-button", text: I18n.t("project_message_form.service_type_placeholder", locale: :en)
    assert_select "[data-biz-map-target='companyPanel']:not([hidden])", count: 0
  end

  test "mobile news descriptions are visible without waiting for JavaScript" do
    get root_path, headers: {"HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 Version/17.0 Mobile/15E148 Safari/604.1"}
    assert_response :success
    assert_select ".news-card.hover-card-visible .hover-card-panel", count: 3
  end

  test "static error pages have CSS QR controls without Alpine" do
    %w[404 500].each do |status|
      get "/#{status}.html"
      assert_response :success
      assert_select "script[src*='alpine']", count: 0
      assert_empty Nokogiri::HTML(response.body).xpath("//@*[starts-with(name(), 'x-')]")
      assert_select ".social-qr button[aria-label]", minimum: 1
      assert_select ".social-qr a", count: 0
      assert_select ".social-qr .social-qr-image", minimum: 1
    end
  end
end
