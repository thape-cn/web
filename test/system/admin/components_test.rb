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

  test "dashboard module groups share the reference navigation and keyboard behavior" do
    assert_selector ".admin-module-navigation li a", count: Admin::Resource.all.size
    Admin::ApplicationHelper::NAVIGATION_GROUPS.each_with_index do |group, index|
      assert_selector "nav[aria-labelledby='module-group-#{index}'] li", count: group[:keys].size
      assert_selector "#module-group-#{index}", text: group[:label]
    end
    [320, 640, 1024].each do |width|
      resize_viewport(width, 1000)
      assert page.evaluate_script(<<~JS), "Module groups should align with their card headings at #{width}px"
        (() => {
          return Array.from(document.querySelectorAll('.admin-module-navigation')).every(nav => {
            const heading = nav.previousElementSibling.querySelector('h3').getBoundingClientRect()
            return Array.from(nav.querySelectorAll('a')).every(link => {
              const bounds = link.getBoundingClientRect()
              const icon = link.querySelector('svg').getBoundingClientRect()
              return bounds.height === 40 && icon.width === 24 && icon.height === 24 &&
                Math.abs(icon.left - heading.left) < 2 && bounds.right <= nav.getBoundingClientRect().right
            })
          }) && document.documentElement.scrollWidth <= innerWidth
        })()
      JS
      page.execute_script("document.querySelector('.admin-module-heading').scrollIntoView({block: 'center'})")
      screenshot("module-groups-#{width}")
    end
    page.execute_script("document.querySelector('.admin-module-link').focus()")
    page.send_keys(:tab)
    page.send_keys([:shift, :tab])
    assert_selector ".admin-module-link:focus-visible"
    assert_equal page.evaluate_script("getComputedStyle(document.querySelector('.admin-module-link')).color"),
      page.evaluate_script("getComputedStyle(document.querySelector('.admin-module-link svg')).color")
    page.send_keys(:enter)
    assert_current_path admin_works_path(locale: :cn)
  end

  test "dashboard cards keep reference text rows at narrow desktop and tablet widths" do
    [320, 640, 768, 1024, 1280].each do |width|
      resize_viewport(width, 1000)
      assert page.evaluate_script(<<~JS), "Dashboard card labels should fit at #{width}px"
        (() => {
          const labels = document.querySelectorAll('.admin-stat-link, .admin-quick-description')
          return Array.from(labels).every(label => {
            const bounds = label.getBoundingClientRect()
            const parent = label.parentElement.getBoundingClientRect()
            return bounds.height === 20 && bounds.right <= parent.right &&
              label.title === label.textContent.trim()
          }) && document.documentElement.scrollWidth <= innerWidth
        })()
      JS
      if width < 1024
        assert_equal "24px", page.evaluate_script("getComputedStyle(document.querySelector('[data-admin-menu-open] svg')).width")
      end
      screenshot("dashboard-card-text-#{width}") if [640, 1024].include?(width)
    end
    resize_viewport(390, 844)
    click_button "打开管理菜单"
    assert_selector "#admin-navigation[open]"
    assert_equal "24px", page.evaluate_script("getComputedStyle(document.querySelector('[data-admin-menu-close] svg')).width")
    click_button "关闭管理菜单"
    assert_selector "[data-admin-menu-open]:focus"
    find(".admin-stat-card", text: "官网作品").click
    assert_current_path admin_works_path(locale: :cn)
  end

  test "picture filenames stay available while long names keep card actions aligned" do
    filename = "#{"long-picture-name-" * 12}图片.png"
    {99107 => filename, 99108 => filename, 99109 => "short.png"}.each do |id, name|
      picture = Picture.new(id: id)
      picture.save!(validate: false)
      picture.update_column(:image, name)
    end
    visit admin_pictures_path(per_page: 3)
    [99107, 99108].each do |id|
      assert_selector "#record-#{id} .admin-media-title[title]", text: filename
      assert_equal "#{filename} · 图片 ##{id}", find("#record-#{id} .admin-media-link")["aria-label"]
    end
    [320, 390, 1024, 1280].each do |width|
      resize_viewport(width, 1000)
      assert page.evaluate_script(<<~JS), "Long picture names should keep card rows aligned at #{width}px"
        (() => {
          const cards = Array.from(document.querySelectorAll('.admin-media-card'))
          const actions = cards.map(card => card.querySelector('.admin-row-actions').getBoundingClientRect())
          const longName = document.querySelector('#record-99108 .admin-media-title')
          return cards.every(card => card.querySelector('.admin-media-title').getBoundingClientRect().height === 20) &&
            longName.scrollWidth > longName.clientWidth && Math.abs(actions[0].top - actions[1].top) < 2 &&
            document.documentElement.scrollWidth <= innerWidth
        })()
      JS
      screenshot("media-filenames-#{width}") if [390, 1280].include?(width)
    end
    find("#record-99108 .admin-media-link").click
    assert_selector "h1", text: "图床 · 编辑"
    assert_current_path edit_admin_picture_path(99108, locale: :cn)
  end

  test "picture library shows five by five on desktop and filters remain usable on phones" do
    26.times do |index|
      picture = Picture.new(id: 99200 + index)
      picture.save!(validate: false)
      picture.update_column(:image, "grid-library-#{index}.PNG")
    end
    visit admin_pictures_path
    resize_viewport(1274, 948)
    assert_selector ".admin-media-grid > li", count: 25
    assert page.evaluate_script(<<~JS), "The default desktop page should contain five rows of five pictures"
      (() => {
        const cards = Array.from(document.querySelectorAll('.admin-media-grid > li'))
        const rows = new Map()
        cards.forEach(card => {
          const top = card.getBoundingClientRect().top
          rows.set(top, (rows.get(top) || 0) + 1)
        })
        return rows.size === 5 && Array.from(rows.values()).every(count => count === 5)
      })()
    JS
    screenshot("picture-filters-desktop")
    [320, 390, 768, 1024, 1274].each do |width|
      resize_viewport(width, 948)
      assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth"), "Picture library should fit at #{width}px"
    end
    resize_viewport(390, 844)
    fill_in "搜索文件名或图片 ID", with: "grid-library-"
    select "PNG", from: "文件类型"
    select "无内容引用", from: "内容引用"
    click_button "筛选"
    assert_selector ".admin-media-grid > li", count: 25
    assert_selector ".admin-active-filters li", count: 3
    screenshot("picture-filters-mobile")
    click_link "列表", exact: true
    assert_selector "tbody tr", count: 25
    assert_selector 'input[name="q"][value="grid-library-"]'
    assert_selector 'select[name="file_type"] option[selected]', text: "PNG"
    click_link "清除筛选", exact: true
    assert_no_selector ".admin-active-filters li"
    assert_selector '.admin-view-switch a[aria-current="true"]', text: "列表"
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
    [390, 1280].each do |width|
      resize_viewport(width, 1000)
      assert page.evaluate_script(<<~JS), "Native upload buttons should match secondary actions at #{width}px"
        (() => {
          const upload = getComputedStyle(document.querySelector('.admin-file-input'), '::file-selector-button')
          const action = getComputedStyle(document.querySelector('.admin-save-bar .admin-button-secondary'))
          return ['fontSize', 'fontWeight', 'lineHeight', 'borderTopWidth', 'borderRadius', 'boxShadow', 'color']
            .every(property => upload[property] === action[property]) &&
            document.documentElement.scrollWidth <= innerWidth
        })()
      JS
    end
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

  test "record pickers preserve selections support keyboard clear and block unfinished searches" do
    work = Admin::Work.create!(id: 99501, city_id: cities(:city_1).id, published: false)
    Admin::Work.translation_class.insert_all!([{id: 99501, work_id: work.id, locale: "cn", project_name: "Picker browser work", created_at: Time.current, updated_at: Time.current}])
    home = TailHome.first || TailHome.create!(id: 99501)
    home.update!(new_project_1_id: work.id, new_project_2_id: 999999999)
    visit edit_admin_tail_home_path
    picker = find("[data-admin-record-picker]", match: :first)
    within(picker) do
      assert_selector '[data-admin-picker-search][value*="Picker browser work"]'
      assert_selector '[data-admin-picker-id][value="99501"]', visible: :hidden
      assert_text "未发布"
      find("[data-admin-picker-search]").set("Unfinished query")
      assert page.evaluate_script("document.querySelector('[data-admin-picker-search]').validity.customError")
      find("[data-admin-picker-search]").set("#99501")
      assert_selector '[role="option"]', text: "Picker browser work"
      find("[data-admin-picker-search]").send_keys(:arrow_down, :enter)
      assert_selector '[data-admin-picker-search][value*="Picker browser work"]'
      find("[data-admin-picker-clear]").click
      assert_equal "", find("[data-admin-picker-id]", visible: :hidden).value
      find("[data-admin-picker-search]").set("#99501")
      assert_selector '[role="option"]'
      find("[data-admin-picker-search]").send_keys(:arrow_down, :enter)
    end
    assert_selector '[data-admin-picker-search][value*="999999999"]'
    [1400, 390].each do |width|
      resize_viewport(width, 1000)
      within(picker) do
        find("[data-admin-picker-search]").click
        assert_selector '[role="option"]'
        screenshot("record-picker-#{width}")
        find("[data-admin-picker-search]").send_keys(:escape)
        assert_no_selector '[role="listbox"]'
      end
      assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
    end
    click_button "保存"
    assert_selector ".admin-alert-success", text: "保存成功"
    assert_equal work.id, home.reload.new_project_1_id
    assert_equal 999999999, home.new_project_2_id
  end

  test "picture inspector loads details supports menus cancellation and full page fallback" do
    picture = Picture.new(id: 99511)
    picture.save!(validate: false)
    picture.update_column(:image, "missing-inspector.png")
    picture.reload
    news = Admin::Info.create!(id: 99511, title: "Inspector owner", introduction: "Intro", content: "<img src='#{picture.image.url}'>")
    visit admin_pictures_path
    [1400, 390].each do |width|
      resize_viewport(width, 1000)
      within("#record-#{picture.id}") { find("[data-admin-picture-open]").click }
      assert_selector "#admin-picture-drawer[open] [data-admin-picture-details]"
      within("#admin-picture-drawer") do
        assert_text "missing-inspector.png"
        assert_selector ".admin-picture-usage-links a[href*='/admin/infos/#{news.id}/edit']"
        assert_selector "[data-admin-media-placeholder]", text: "暂无图片"
        find("summary").click
        assert_selector "details[open]"
        screenshot("picture-inspector-menu-#{width}")
        page.send_keys(:escape)
        assert_no_selector "details[open]"
        assert_selector "summary:focus"
        assert page.evaluate_script("document.getElementById('admin-picture-drawer').open")
        find("summary").click
        click_button "删除"
      end
      assert_selector "#admin-confirmation[open]"
      screenshot("picture-inspector-confirm-#{width}")
      within("#admin-confirmation") { click_button "取消" }
      assert Picture.exists?(picture.id)
      assert_selector "#admin-picture-drawer[open]"
      page.send_keys(:escape)
      assert_no_selector "#admin-picture-drawer details[open]"
      page.send_keys(:escape)
      assert_no_selector "#admin-picture-drawer[open]"
      assert_selector "#record-#{picture.id} [data-admin-picture-open]:focus"
      assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
    end
    visit admin_picture_path(picture)
    assert_selector "[data-admin-picture-details]"
    assert_no_selector "#admin-picture-drawer"
    visit admin_pictures_path
    within("#record-#{picture.id}") { find("[data-admin-picture-open]").click }
    within("#admin-picture-drawer") do
      assert_selector "[data-admin-picture-details]"
      find("summary").click
      click_button "删除"
    end
    within("#admin-confirmation") { click_button "确认删除" }
    assert_selector ".admin-alert-success", text: "删除成功"
    assert_not Picture.exists?(picture.id)
  end

  test "message inbox and table selection confirm only current page and clear after navigation" do
    ProjectMessage.insert_all!(3.times.map { |i| {id: 99520 + i, name: "Message sender #{i}", company: "Company", message: "<script>unsafe()</script>" * 20, spam_score: i.zero? ? nil : 8, created_at: Time.current, updated_at: Time.current} })
    [1400, 390].each do |width|
      resize_viewport(width, 1000)
      visit admin_project_messages_path(per_page: 2)
      assert_selector ".admin-message-inbox > li", count: 2
      assert_no_selector ".admin-message-preview script"
      assert_button "删除所选留言", disabled: true
      find('[data-admin-message-select][value="99522"]').check
      assert_text "已选择 1 条留言"
      assert page.evaluate_script("document.querySelector('[data-admin-select-page]').indeterminate")
      screenshot("message-inbox-#{width}")
      check "选择本页"
      assert_text "已选择 2 条留言"
      click_button "删除所选留言"
      assert_selector "#admin-confirmation", text: "确认删除所选的 2 条留言"
      screenshot("message-bulk-confirm-#{width}")
      within("#admin-confirmation") { click_button "取消" }
      assert_equal 3, ProjectMessage.where(id: 99520..99522).count
      click_link "表格", exact: true
      assert_selector ".admin-table tbody tr", count: 2
      assert_button "删除所选留言", disabled: true
      check "选择本页"
      screenshot("message-table-#{width}")
      click_link "收件箱", exact: true
      assert_button "删除所选留言", disabled: true
      assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
    end
    check "选择本页"
    click_button "删除所选留言"
    within("#admin-confirmation") { click_button "确认删除" }
    assert_selector ".admin-alert-success", text: "已删除 2 条留言"
    assert_equal [99520], ProjectMessage.where(id: 99520..99522).pluck(:id)
  end

  test "picker and drawer request failures provide recoverable states" do
    visit edit_admin_tail_home_path
    page.execute_script("window.fetch = () => Promise.reject(new Error('Offline test'))")
    picker = find("[data-admin-record-picker]", match: :first)
    within(picker) do
      find("[data-admin-picker-search]").set("unavailable")
      assert_text "查找失败，请重试。"
      find("[data-admin-picker-clear]").click
    end
    picture = Picture.new(id: 99531)
    picture.save!(validate: false)
    picture.update_column(:image, "failure.png")
    visit admin_pictures_path
    page.execute_script("window.fetch = () => Promise.reject(new Error('Offline test'))")
    within("#record-#{picture.id}") { find("[data-admin-picture-open]").click }
    within("#admin-picture-drawer") do
      assert_text "无法加载图片详情。"
      click_link "打开详情页"
    end
    assert_current_path admin_picture_path(picture, locale: :cn)
    assert_selector "[data-admin-picture-details]"
  end

  test "record inputs picture links and individual message selection work without JavaScript" do
    page.driver.browser.execute_cdp("Emulation.setScriptExecutionDisabled", value: true)
    home = TailHome.first || TailHome.create!(id: 99560)
    visit edit_admin_tail_home_path
    assert_selector "[data-admin-picker-id]", count: 10
    assert_no_selector "[data-admin-picker-controls]"
    find('input[name="tail_home[new_project_1_id]"]').set("999999999")
    click_button "保存"
    assert_selector ".admin-alert-success", text: "保存成功"
    assert_equal 999999999, home.reload.new_project_1_id

    picture = Picture.new(id: 99560)
    picture.save!(validate: false)
    picture.update_column(:image, "native-fallback.png")
    visit admin_pictures_path
    within("#record-#{picture.id}") { find("[data-admin-picture-open]").click }
    assert_selector "[data-admin-picture-details]"
    assert_no_selector "#admin-picture-drawer"

    ProjectMessage.insert_all!([{id: 99560, name: "Native selection", message: "No script", created_at: Time.current, updated_at: Time.current}])
    visit admin_project_messages_path
    assert_no_selector "[data-admin-message-count]"
    find('[data-admin-message-select][value="99560"]').check
    find("noscript input[required]").check
    click_button "删除所选留言"
    assert_selector ".admin-alert-success", text: "已删除 1 条留言"
    assert_not ProjectMessage.exists?(99560)
  ensure
    page.driver.browser.execute_cdp("Emulation.setScriptExecutionDisabled", value: false)
  end
end
