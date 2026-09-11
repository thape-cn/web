# frozen_string_literal: true

require "application_system_test_case"

class Admin::MaintenanceTest < ApplicationSystemTestCase
  setup do
    Admin::User.create!(id: 99001, name: "Admin", email: "browser@example.test", password: "browser-test-password")
    Admin::User.create!(id: 99002, name: "Removable admin", email: "remove@example.test", password: "browser-test-password")
  end

  test "login navigation saving and confirmed deletion work in the browser" do
    visit admin_login_path
    fill_in "邮箱", with: "browser@example.test"
    fill_in "密码", with: "browser-test-password"
    click_button "登录"
    assert_selector "h1", text: "网站管理"
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/dashboard.png")) # standard:disable Lint/Debugger

    within "nav" do
      click_link "城市", exact: true
    end
    first(:link, "编辑").click
    find('input[name="city[name]"]').set("浏览器测试城市")
    click_button "保存"
    assert_text "保存成功"
    assert_text "浏览器测试城市"
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/cities.png")) # standard:disable Lint/Debugger

    within("nav") { click_link "官网作品" }
    assert_text "发布"
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/works.png")) # standard:disable Lint/Debugger

    within("nav") { click_link "网站管理员" }
    within(find("tr", text: "Removable admin")) do
      accept_confirm { click_button "删除" }
    end
    assert_no_text "Removable admin"
    resize_viewport(390, 844)
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/mobile.png")) # standard:disable Lint/Debugger
    click_button "退出登录"
    assert_selector "h1", text: "管理员登录"
  end
end
