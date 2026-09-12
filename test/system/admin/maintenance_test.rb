# frozen_string_literal: true

require "application_system_test_case"

class Admin::MaintenanceTest < ApplicationSystemTestCase
  setup do
    Admin::User.create!(id: 99001, name: "Admin", email: "browser@example.test", password: "browser-test-password")
    Admin::User.create!(id: 99002, name: "Removable admin", email: "remove@example.test", password: "browser-test-password")
  end

  test "login navigation saving and confirmed deletion work in the browser" do
    visit admin_login_path
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/login.png")) # standard:disable Lint/Debugger
    fill_in "邮箱", with: "browser@example.test"
    fill_in "密码", with: "browser-test-password"
    click_button "登录"
    assert_selector "h1", text: "网站管理"
    assert_no_button "打开管理菜单"
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/dashboard.png")) # standard:disable Lint/Debugger

    within "nav" do
      click_link "城市", exact: true
    end
    first(:link, "编辑").click
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/city-form.png")) # standard:disable Lint/Debugger
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
    assert_no_selector "dialog[open]"
    click_button "打开管理菜单"
    assert_selector 'button[data-admin-menu-open][aria-expanded="true"]'
    assert_selector "dialog[open]"
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/mobile-menu.png")) # standard:disable Lint/Debugger
    page.send_keys(:escape)
    assert_no_selector "dialog[open]"
    assert_selector 'button[data-admin-menu-open][aria-expanded="false"]:focus'
    click_button "打开管理菜单"
    within("dialog nav") { click_link "官网作品" }
    assert_selector "h1", text: "官网作品"
    assert_no_selector "dialog[open]"
    assert page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth"), "Mobile page should not overflow horizontally"
    click_button "打开管理菜单"
    click_button "退出登录"
    assert_selector "h1", text: "管理员登录"
  end

  test "filters language selection and the project editor remain usable" do
    visit admin_login_path
    fill_in "邮箱", with: "browser@example.test"
    fill_in "密码", with: "browser-test-password"
    click_button "登录"
    within("nav") { click_link "官网作品" }
    assert_selector '.admin-sidebar nav a[aria-current="page"]', text: "官网作品"
    fill_in "搜索名称 / 标题", with: "no-matching-project-for-admin-ui"
    click_button "筛选"
    assert_text "没有找到匹配的记录"
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/empty-search.png")) # standard:disable Lint/Debugger
    first(:link, "清除筛选").click
    assert_selector "tbody tr"
    click_link "EN", exact: true
    assert_selector '.admin-locale a[aria-current="true"]', text: "EN"
    click_link "新建", exact: true
    assert_text "当前内容 · English"
    assert_selector 'input[type="file"][name*="work_pictures_attributes"]', count: 6
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/work-form.png")) # standard:disable Lint/Debugger
    resize_viewport(390, 844)
    assert page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth"), "Mobile editor should not overflow horizontally"
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/mobile-form.png")) # standard:disable Lint/Debugger
    click_link "取消"
    assert_selector "h1", text: "官网作品"
  end
end
