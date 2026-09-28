# frozen_string_literal: true

require "application_system_test_case"

class Admin::OrderingTest < ApplicationSystemTestCase
  setup do
    Admin::User.create!(id: 99005, name: "Ordering editor", email: "ordering@example.test", password: "browser-test-password")
    @first = Portfolio.create!(id: 99201, title: "First portfolio", position: 0)
    @second = Portfolio.create!(id: 99202, title: "Second portfolio", position: 1)
    @third = Portfolio.create!(id: 99203, title: "Third portfolio", position: 2)
    visit admin_login_path
    fill_in "邮箱", with: "ordering@example.test"
    fill_in "密码", with: "browser-test-password"
    click_button "登录"
    assert_selector "h1", text: "网站管理"
    visit admin_portfolios_path(locale: :cn)
    assert_selector "[data-admin-order-table]"
  end

  test "arrows and move dialog save ordering and restore focus on keyboard dismissal" do
    assert_selector "#record-#{@first.id} button[value='up'][disabled]"
    find("#record-#{@first.id} button[value='down']").click
    assert_order [@second, @first, @third]
    find("#record-#{@first.id} button[value='up']").click
    assert_order [@first, @second, @third]

    open_move(@third)
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/ordering-dialog.png")) # standard:disable Lint/Debugger
    click_button "移到顶部"
    assert_order [@third, @first, @second]
    open_move(@third)
    click_button "移到底部"
    assert_order [@first, @second, @third]

    open_move(@third)
    within(".admin-order-dialog .admin-order-destination", match: :first) do
      fill_in "移到第几条（1–3）", with: 2
      click_button "移动", exact: true
    end
    assert_order [@first, @third, @second]
    open_move(@first)
    within(".admin-order-dialog .admin-order-destination", match: :first) do
      fill_in "移到第几条（1–3）", with: 0
      click_button "移动", exact: true
    end
    assert_selector "dialog[open]"
    assert_equal [@first.id, @third.id, @second.id], Portfolio.order(:position).pluck(:id)
    page.send_keys(:escape)
    assert_no_selector "dialog[open]"
    assert_selector "#record-#{@first.id} summary:focus"

    open_move(@first)
    within all(".admin-order-dialog .admin-order-destination").last do
      fill_in "移到指定记录旁（输入记录 ID）", with: @second.id
      select "该记录之后", from: "order-side-#{@first.id}"
      click_button "移动", exact: true
    end
    assert_order [@third, @second, @first]
    visit current_url
    assert_equal [@third.id, @second.id, @first.id], displayed_ids
  end

  test "dragging saves the drop location and the dialog fits on mobile" do
    find("#record-#{@first.id} [data-admin-drag-handle]").drag_to(find("#record-#{@third.id} .admin-record-name"))
    assert_order [@second, @third, @first]
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/ordering-desktop.png")) # standard:disable Lint/Debugger

    resize_viewport(390, 844)
    open_move(@third)
    assert page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth"), "Mobile list should not overflow"
    assert page.evaluate_script("document.querySelector('[data-admin-order-dialog]').getBoundingClientRect().right <= window.innerWidth"), "Move dialog should fit on mobile"
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/ordering-mobile.png")) # standard:disable Lint/Debugger
    click_button "移到顶部"
    assert_order [@third, @second, @first]
  end

  private

  def open_move(record)
    find("#record-#{record.id} summary").click
    assert_selector "dialog[open]"
  end

  def displayed_ids
    all("tr[data-record-id]").map { |row| row["data-record-id"].to_i }
  end

  def assert_order(records)
    assert_text "排序已保存"
    records.each_with_index do |record, index|
      assert_selector "tbody tr:nth-child(#{index + 1})[data-record-id='#{record.id}']"
    end
    assert_equal records.map(&:id), displayed_ids
    assert_equal records.map(&:id), Portfolio.order(:position).pluck(:id)
  end
end
