# frozen_string_literal: true

require "application_system_test_case"
require "tempfile"

class Admin::ComponentsTest < ApplicationSystemTestCase
  setup do
    @original_upload_root = PictureUploader.root
    @upload_root = Dir.mktmpdir("admin-components-uploads")
    PictureUploader.root = @upload_root
    Admin::User.create!(id: 99101, name: "Components admin", email: "components@example.test", password: "components-test-password")
    Admin::User.create!(id: 99102, name: "Dialog target", email: "dialog@example.test", password: "components-test-password")
    visit admin_login_path
    fill_in "邮箱", with: "components@example.test"
    fill_in "密码", with: "components-test-password"
    click_button "登录"
    assert_selector "h1", text: "网站管理"
  end

  teardown do
    PictureUploader.root = @original_upload_root
    FileUtils.remove_entry(@upload_root) if @upload_root && File.exist?(@upload_root)
  end

  def screenshot(name)
    directory = Rails.root.join("tmp/screenshots/admin/components")
    FileUtils.mkdir_p(directory)
    page.save_screenshot(directory.join("#{name}.png")) # standard:disable Lint/Debugger
  end

  test "module search supports keyboard selection dismissal and singleton navigation" do
    assert_selector '[data-admin-count="works"]'
    screenshot("dashboard-desktop")
    page.send_keys([:control, "k"])
    assert_selector "#admin-module-query:focus"
    fill_in "搜索管理模块", with: "no-module-matches"
    assert_text "没有找到匹配的模块"
    fill_in "搜索管理模块", with: "tail_homes"
    assert_selector "#admin-module-results a", count: 1
    page.send_keys(:arrow_down)
    assert_selector "#admin-module-results a:focus", text: "官网首页"
    screenshot("module-dialog-desktop")
    page.send_keys(:escape)
    assert_no_selector "dialog[open]"
    resize_viewport(390, 844)
    screenshot("dashboard-mobile")
    click_button "搜索管理模块"
    fill_in "搜索管理模块", with: "作品"
    screenshot("module-dialog-mobile")
    page.send_keys(:escape)
    assert_selector "[data-admin-switcher-open]:focus"
    click_button "搜索管理模块"
    fill_in "搜索管理模块", with: "官网首页"
    page.send_keys(:enter)
    assert_selector "h1", text: "官网首页 · 编辑"
    assert_selector ".admin-section-navigation a"
    assert_no_selector "dialog[open]"
    assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
  end

  test "filtered lists editor sections inline validation and media views fit desktop and phones" do
    visit admin_works_path(published: "true", city_id: cities(:city_1).id, per_page: 1)
    assert_selector ".admin-filter-bar"
    screenshot("filtered-list-desktop")
    click_link "EN", exact: true
    assert_selector '.admin-filter-tabs a[aria-current="page"]', text: "已发布"
    assert_selector "#city_id option[selected]", text: "上海"
    resize_viewport(390, 844)
    screenshot("filtered-list-mobile")
    assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
    click_link "新建", exact: true
    click_link "项目图片", exact: true
    assert_selector "#gallery-heading"
    assert_selector 'input[type="file"][name*="work_pictures_attributes"]', count: 6
    screenshot("editor-gallery-mobile")
    page.execute_script("window.scrollTo(0, 0)")
    screenshot("editor-mobile")
    resize_viewport(1440, 1000)
    screenshot("editor-desktop")

    visit new_admin_info_path
    fill_in "标题", with: "Validation retained title"
    click_button "保存"
    assert_selector '#info_introduction[aria-invalid="true"]'
    assert_selector '.simditor-body[aria-invalid="true"]'
    assert_selector "#info_introduction_error"
    assert_field "标题", with: "Validation retained title"

    file = Tempfile.new(["component", ".png"])
    file.binmode
    file.write(Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aXioAAAAASUVORK5CYII="))
    file.flush
    Picture.create!(id: 99103, image: Rack::Test::UploadedFile.new(file.path, "image/png"))
    file.close!
    Picture.find(99103).update_column(:image, "missing-component-image.png")
    visit admin_pictures_path(per_page: 1)
    assert_selector ".admin-media-card"
    assert_selector "[data-admin-media-placeholder]:not([hidden])"
    screenshot("media-grid-desktop")
    click_link "列表", exact: true
    assert_selector "tbody tr#record-99103"
    click_link "网格", exact: true
    resize_viewport(390, 844)
    screenshot("media-grid-mobile")
    assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
  end

  test "confirmation cancellation escape focus and single submission retain native fallback" do
    visit admin_users_path
    assert_selector "h1", text: "网站管理员"
    row = find("#record-99102")
    within(row) { click_button "删除" }
    assert_selector "#admin-confirmation [data-admin-confirm-cancel]:focus"
    assert_text "Dialog target"
    screenshot("confirmation-desktop")
    page.send_keys(:escape)
    assert_selector "#record-99102 .admin-danger-link:focus"
    assert Admin::User.exists?(99102)
    within(row) { click_button "删除" }
    within("#admin-confirmation") { click_button "取消" }
    assert_no_selector "dialog[open]"
    assert Admin::User.exists?(99102)
    resize_viewport(390, 844)
    within(row) { click_button "删除" }
    screenshot("confirmation-mobile")
    page.execute_script(<<~JS)
      sessionStorage.setItem("adminConfirmationSubmissions", "0")
      document.querySelector("#record-99102 form").addEventListener("submit", () => {
        sessionStorage.setItem("adminConfirmationSubmissions", String(Number(sessionStorage.getItem("adminConfirmationSubmissions")) + 1))
      })
      const accept = document.querySelector("[data-admin-confirm-accept]")
      accept.click()
      accept.click()
    JS
    assert_no_selector "#record-99102"
    assert_text "删除成功"
    assert_not Admin::User.exists?(99102)
    assert_equal "1", page.evaluate_script('sessionStorage.getItem("adminConfirmationSubmissions")')
    assert_selector "#record-99101 .admin-danger-link", count: 0
    click_button "关闭提示"
    assert_no_text "删除成功"

    # Disabling dialog support exercises the unchanged Rails UJS fallback.
    Admin::User.create!(id: 99104, name: "Fallback target", email: "fallback@example.test", password: "components-test-password")
    visit admin_users_path
    assert_selector "#record-99104"
    page.execute_script("document.getElementById('admin-confirmation').showModal = null")
    within("#record-99104") do
      dismiss_confirm { click_button "删除" }
    end
    assert_no_selector "dialog[open]"
  end

  test "filter tabs and chips navigate while retaining search and language" do
    visit admin_works_path(q: "no-component-match", published: "true", city_id: cities(:city_1).id, per_page: 50, locale: :en)
    within(".admin-filter-tabs") { click_link "未发布" }
    assert_field "搜索名称 / 标题", with: "no-component-match"
    assert_selector '.admin-filter-tabs a[aria-current="page"]', text: "未发布"
    within(".admin-active-filters") { click_link "搜索：no-component-match" }
    assert_field "搜索名称 / 标题", with: ""
    assert_selector "#city_id option[selected]", text: "上海"
    assert_selector "#per_page option[selected]", text: "50"
    assert_selector '.admin-locale a[aria-current="true"]', text: "EN"
    fill_in "搜索名称 / 标题", with: "new-component-search"
    click_button "筛选"
    assert_selector '.admin-filter-tabs a[aria-current="page"]', text: "未发布"
    resize_viewport(390, 844)
    screenshot("filter-tabs-mobile")
    assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
  end

  test "switches and checkbox lists work with keyboard and persist empty selections" do
    # The schema snapshot omits generated IDs on these tables, as in the
    # integration suite. Restore them transactionally for a real form save.
    connection = ActiveRecord::Base.connection
    %w[work_project_types work_translations].each do |table|
      missing_identity = connection.select_value("SELECT is_identity = 'NO' AND column_default IS NULL FROM information_schema.columns WHERE table_schema = current_schema() AND table_name = '#{table}' AND column_name = 'id'")
      next unless missing_identity
      quoted = connection.quote_table_name(table)
      next_id = connection.select_value("SELECT COALESCE(MAX(id), 0) + 1 FROM #{quoted}").to_i
      connection.execute("ALTER TABLE #{quoted} ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (START WITH #{next_id})")
    end
    work = Admin::Work.unscoped.first
    visit edit_admin_work_path(work, locale: :cn)
    find('label[for="work_published"]').click
    assert_equal !work.published?, find("#work_published", visible: :all).checked?
    # The label focuses the native input; Space changes the same checkbox.
    page.send_keys(:space)
    assert_equal work.published?, find("#work_published", visible: :all).checked?
    within(".admin-checkbox-group", text: "大类别") do
      check "居住"
      check "商务办公"
    end
    page.execute_script("document.querySelector('.admin-switch-panel').scrollIntoView(); window.scrollBy(0, -100)")
    screenshot("form-controls-desktop")
    resize_viewport(390, 844)
    page.execute_script("document.querySelector('.admin-switch-panel').scrollIntoView(); window.scrollBy(0, -100)")
    screenshot("form-controls-mobile")
    assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
    click_button "保存"
    assert_text "保存成功"
    assert_includes work.reload.project_type_ids, 1
    assert_includes work.project_type_ids, 3
    visit edit_admin_work_path(work, locale: :cn)
    within(".admin-checkbox-group", text: "大类别") do
      all('input[type="checkbox"]:checked').each(&:uncheck)
    end
    click_button "保存"
    assert_text "保存成功"
    assert_empty work.reload.project_type_ids
  end

  test "upload previews can be cancelled without losing existing files or cached inputs" do
    file = Tempfile.new(["preview", ".png"])
    file.binmode
    file.write(Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aXioAAAAASUVORK5CYII="))
    file.flush
    picture = Picture.create!(id: 99105, image: Rack::Test::UploadedFile.new(file.path, "image/png"))
    visit edit_admin_picture_path(picture)
    within("[data-admin-upload]") do
      assert_selector "[data-admin-upload-current] a", text: File.basename(file.path)
      attach_file "图片", file.path
      assert_selector '[data-admin-upload-preview][src^="blob:"]'
      assert_selector "[data-admin-upload-filename]", text: File.basename(file.path)
      assert_no_selector "[data-admin-upload-current]"
      page.execute_script("document.querySelector('[data-admin-upload]').scrollIntoView(); window.scrollBy(0, -100)")
      screenshot("upload-preview-desktop")
      resize_viewport(390, 844)
      page.execute_script("document.querySelector('[data-admin-upload]').scrollIntoView(); window.scrollBy(0, -100)")
      screenshot("upload-preview-mobile")
      assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
      click_button "取消选择"
      assert_no_selector "[data-admin-upload-pending]"
      assert_selector "[data-admin-upload-current] a"
      assert_selector "[data-admin-upload-input]:focus"
      assert_selector 'input[name="picture[image_cache]"]', visible: :all
    end
    click_button "保存"
    assert_text "保存成功"
    assert_equal File.basename(file.path), picture.reload.image.identifier
    visit new_admin_work_path
    within('section[aria-labelledby="gallery-heading"] [data-admin-upload]', match: :first) do
      attach_file file.path
      assert_selector '[data-admin-upload-preview][src^="blob:"]'
    end
    assert_selector "[data-admin-upload-pending]", count: 1
  ensure
    file&.close!
  end
end
