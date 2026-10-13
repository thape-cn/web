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
    page.send_keys(:tab)
    page.send_keys(:tab)
    assert_selector ".admin-command-link.admin-command-active:focus"
    fill_in "搜索管理模块", with: "no-module-matches"
    assert_text "没有找到匹配的模块"
    assert_text "请尝试其他名称或关键词。"
    assert_no_selector ".admin-command-link.admin-command-active"
    screenshot("module-empty-desktop")
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
    assert page.evaluate_script(<<~JS)
      (() => {
        const section = document.querySelector('.admin-editor-section')
        return Math.abs(section.querySelector('h2').getBoundingClientRect().left -
          section.querySelector('.admin-label').getBoundingClientRect().left) < 2
      })()
    JS
    screenshot("editor-mobile")
    [1280, 1440, 1600].each do |width|
      resize_viewport(width, 1000)
      assert page.evaluate_script(<<~JS), "Editor cards and fields should fit at #{width}px"
        (() => {
          const section = document.querySelector('.admin-editor-section')
          const heading = section.querySelector('.admin-editor-heading').getBoundingClientRect()
          const card = section.querySelector('.admin-form-section').getBoundingClientRect()
          const input = section.querySelector('.admin-input').getBoundingClientRect()
          return heading.right < card.left && Math.abs(heading.top - card.top) < 2 &&
            input.width >= 200 && input.right <= card.right &&
            document.documentElement.scrollWidth <= innerWidth
        })()
      JS
    end
    screenshot("editor-wide-desktop")
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
    find("#record-99103 .admin-media-link").click
    assert_selector "h1", text: "图床 · 编辑"
    visit admin_pictures_path(per_page: 1)
    resize_viewport(390, 844)
    screenshot("media-grid-mobile")
    assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
  end

  test "admin theme and dialog backdrops match the reference states" do
    assert_equal "20px", page.evaluate_script("getComputedStyle(document.querySelector('.admin-stat-card dt')).lineHeight")
    assert_equal "36px", page.evaluate_script("getComputedStyle(document.querySelector('.admin-stat-card dd')).lineHeight")
    assert_equal "16px", page.evaluate_script("getComputedStyle(document.querySelector('.admin-eyebrow')).lineHeight")
    assert_equal "oklch(0.21 0.034 264.665)", page.evaluate_script("getComputedStyle(document.querySelector('.admin-sidebar')).backgroundColor")
    visit admin_users_path
    assert_equal "oklch(0.511 0.262 276.966)", page.evaluate_script("getComputedStyle(document.querySelector('.admin-button')).backgroundColor")
    within("#record-99102") { click_button "删除" }
    # Clicks on panel whitespace must leave the dialog open.
    page.execute_script(<<~JS)
      const panel = document.querySelector('#admin-confirmation')
      const bounds = panel.getBoundingClientRect()
      panel.dispatchEvent(new MouseEvent('click', {bubbles: true, clientX: bounds.left + 1, clientY: bounds.top + 1}))
    JS
    assert_selector "#admin-confirmation[open]"
    click_dialog_backdrop("#admin-confirmation")
    assert_no_selector "dialog[open]"
    assert_selector "#record-99102 .admin-danger-link:focus"
    assert Admin::User.exists?(99102)
    click_button "搜索管理模块"
    click_dialog_backdrop("#admin-module-search")
    assert_no_selector "dialog[open]"
    assert_selector "[data-admin-switcher-open]:focus"
    visit admin_works_path
    first(".admin-order-menu summary").click
    assert_selector "#admin-order-dialog[open]"
    click_dialog_backdrop("#admin-order-dialog")
    assert_no_selector "dialog[open]"
    assert_selector ".admin-order-menu summary:focus"
  end

  def click_dialog_backdrop(selector)
    page.execute_script(<<~JS, selector)
      const dialog = document.querySelector(arguments[0])
      dialog.dispatchEvent(new MouseEvent('click', {bubbles: true, clientX: 0, clientY: 0}))
    JS
  end

  test "detail attachments and card edges match the responsive reference" do
    uploader = Admin::Info.uploaders[:pdf_file]
    original_root = uploader.root
    uploader.root = @upload_root
    file = Tempfile.new(["attachment", ".pdf"])
    file.write("%PDF-1.4\n%%EOF")
    file.flush
    info = Admin::Info.find(infos(:info_635).id)
    filename = "#{"long-report-name-" * 12}report.pdf"
    info.pdf_file = Rack::Test::UploadedFile.new(file.path, "application/pdf", original_filename: filename)
    info.save!(validate: false)
    visit admin_info_path(info, locale: :cn)
    assert_selector ".admin-attachment-name", text: filename
    assert_equal "查看文件 #{filename}（新窗口）", find(".admin-attachments a")["aria-label"]
    [390, 640, 1280].each do |width|
      resize_viewport(width, 1000)
      assert page.evaluate_script(<<~JS), "Detail attachments should fit at #{width}px"
        (() => {
          const panel = document.querySelector('.admin-detail-panel')
          const row = document.querySelector('.admin-attachments').closest('.admin-description-row')
          const label = row.querySelector('dt').getBoundingClientRect()
          const value = row.querySelector('dd').getBoundingClientRect()
          const filename = row.querySelector('.admin-attachment-name span')
          const link = row.querySelector('.admin-attachments a').getBoundingClientRect()
          return getComputedStyle(panel).borderTopLeftRadius === (innerWidth < 640 ? '0px' : '8px') &&
            link.right <= value.right && filename.scrollWidth > filename.clientWidth &&
            (innerWidth < 640 ? value.top >= label.bottom : Math.abs(value.top - label.top) < 2) &&
            document.documentElement.scrollWidth <= innerWidth
        })()
      JS
      page.execute_script("document.querySelector('.admin-attachments').scrollIntoView({block: 'center'})")
      screenshot("detail-attachment-#{width}")
    end
    visit admin_infos_path
    [390, 640].each do |width|
      resize_viewport(width, 1000)
      assert_equal((width < 640) ? "0px" : "8px", page.evaluate_script("getComputedStyle(document.querySelector('.admin-list-panel')).borderTopLeftRadius"))
    end
  ensure
    uploader.root = original_root
    file&.close!
  end

  test "SEO cards fit phones and tablets and labels focus their own record" do
    other = Seo.create!(id: 99106, seo_name: "其他页面", home_title: "Original other title")
    resize_viewport(640, 900)
    assert page.evaluate_script(<<~JS)
      (() => {
        const cards = document.querySelectorAll('.admin-quick-card')
        return cards[0].getBoundingClientRect().top === cards[1].getBoundingClientRect().top
      })()
    JS
    visit admin_seos_path
    [390, 640, 768, 1280, 1600].each do |width|
      resize_viewport(width, 1000)
      assert page.evaluate_script(<<~JS), "SEO fields should fit their card at #{width}px"
        (() => {
          const section = document.querySelector('.admin-seo-editor .admin-editor-section')
          const card = section.querySelector('.admin-form-section')
          const title = card.querySelector('input[name="seo[home_title]"]').getBoundingClientRect()
          const description = card.querySelector('textarea').getBoundingClientRect()
          const bounds = card.getBoundingClientRect()
          return document.documentElement.scrollWidth <= innerWidth &&
            title.left >= bounds.left && description.right <= bounds.right &&
            (innerWidth < 640 ? Math.abs(title.width - description.width) < 2 : description.width > title.width * 1.8)
        })()
      JS
      screenshot("seo-editor-#{width}") if [390, 640, 1280].include?(width)
    end
    within(find("#seo-#{seos(:seo_one).id}-heading").find(:xpath, "ancestor::form")) do
      fill_in "Title", with: "Unsaved first title"
    end
    within(find("#seo-#{other.id}-heading").find(:xpath, "ancestor::form")) do
      find('label[for="seo_99106_seo_home_title"]').click
      assert_selector "#seo_99106_seo_home_title:focus"
      fill_in "Title", with: "Updated other title"
      click_button "保存"
    end
    assert_text "保存成功"
    assert_equal "Updated other title", other.reload.home_title
    assert_not_equal "Unsaved first title", seos(:seo_one).reload.home_title
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
    assert_equal "0px", page.evaluate_script("getComputedStyle(document.querySelector('.admin-switch-panel .admin-label')).marginBottom")
    assert_equal "20px", page.evaluate_script("getComputedStyle(document.querySelector('.admin-switch-panel p')).lineHeight")
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
