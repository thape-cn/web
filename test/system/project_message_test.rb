# frozen_string_literal: true

require "application_system_test_case"

class ProjectMessageTest < ApplicationSystemTestCase
  setup do
    page.current_window.resize_to(1400, 1000)
  end

  test "dialog closes with Escape, close button, and backdrop and restores focus" do
    visit_contact(:en)
    assert_no_selector "#project-message-dialog"

    opener = find("[data-action='modal#open']")
    opener.click
    assert_selector "#project-message-dialog"
    assert_equal "hidden", page.evaluate_script("document.body.style.overflow")
    find("#project-message-name").send_keys(:escape)
    assert_no_selector "#project-message-dialog"
    assert_selector "[data-action='modal#open']:focus"
    assert_equal "", page.evaluate_script("document.body.style.overflow")

    opener.click
    find("#project-message-dialog button[aria-label='Close']").click
    assert_no_selector "#project-message-dialog"

    opener.click
    find("#project-message-dialog .fixed[data-action='click->modal#close']").click(x: 5, y: 5, offset: :top_left)
    assert_no_selector "#project-message-dialog"
  end

  %i[cn en].each do |locale|
    test "submits multiple selections and locks the form in #{locale}" do
      visit_contact(locale)
      find("[data-action='modal#open']").click
      project_options = I18n.t("project_message_form.project_type_options", locale: locale)
      service_options = I18n.t("project_message_form.service_type_options", locale: locale)
      separator = I18n.t("project_message_form.selected_separator", locale: locale)
      project_menu = find("#project-message-project_type-button")
      service_menu = find("#project-message-service_type-button")

      within "#project-message-form" do
        fill_in "project-message-name", with: "Frontend integration test"
        fill_in "project-message-phone", with: "13800138000"
        fill_in "project-message-company", with: "Test company"
        fill_in "project-message-area", with: "10000"
        fill_in "project-message-content", with: "Test project inquiry"

        project_menu.click
        check project_options[1]
        check project_options[0]
        assert_text [project_options[1], project_options[0]].join(separator)
        uncheck project_options[1]
        uncheck project_options[0]
        assert_button I18n.t("project_message_form.project_type_placeholder", locale: locale)
        check project_options[0]
        check project_options[1]

        service_menu.click
        assert_no_selector "#project-message-project_type-options"
        check service_options[0]
        check service_options[1]
        find("#project-message-company").click
        assert_no_selector "#project-message-service_type-options"
      end

      notification = Struct.new(:success?, :status).new(true, 200)
      Faraday.stub(:post, ->(*) { notification }) do
        assert_difference("ProjectMessage.count") do
          within "#project-message-form" do
            click_button I18n.t("project_message_form.submit_button", locale: locale)
            assert_button I18n.t("project_message_form.submited_button", locale: locale), disabled: true
          end
        end
      end

      message = ProjectMessage.order(:created_at).last
      assert_equal project_options.first(2).join(separator), message.project_type
      assert_equal service_options.first(2).join(separator), message.service_type
      assert_equal "Test project inquiry", message.message
      assert_selector "#project-message-form input[type=checkbox]:disabled", count: project_options.size + service_options.size, visible: :all
      assert_selector "#project-message-project_type-button:disabled"
      assert_selector "#project-message-service_type-button:disabled"
      assert_selector "#project-message-content:disabled"
    end
  end

  private

  def visit_contact(locale)
    MapContact.stub(:find, MapContact.new) { visit biz_map_path(locale: locale) }
  end
end
