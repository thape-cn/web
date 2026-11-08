# frozen_string_literal: true

require "application_system_test_case"

class Admin::ReferenceParityTest < ApplicationSystemTestCase
  setup do
    Admin::User.create!(id: 99601, name: "Reference admin", email: "reference@example.test", password: "reference-test-password")
    Admin::User.create!(id: 99602, name: "Another admin", email: "another-reference@example.test", password: "reference-test-password")
    visit admin_login_path
    fill_in "邮箱", with: "reference@example.test"
    fill_in "密码", with: "reference-test-password"
    click_button "登录"
    assert_selector "h1", text: "网站管理"
  end

  def screenshot(name)
    directory = Rails.root.join("tmp/screenshots/admin/reference-parity")
    FileUtils.mkdir_p(directory)
    page.save_screenshot(directory.join("#{name}.png")) # standard:disable Lint/Debugger
  end

  test "mobile navigation keeps its brand row and outside close control visible" do
    visit admin_users_path
    [320, 390, 768, 1023].each do |width|
      resize_viewport(width, 844)
      click_button "打开管理菜单"
      assert_selector "#admin-navigation[open]"
      assert page.evaluate_script(<<~JS), "Sidebar contents and outside close control should fit at #{width}px"
        (() => {
          const dialog = document.querySelector('#admin-navigation')
          const panel = dialog.querySelector('.admin-mobile-menu-panel').getBoundingClientRect()
          const brand = dialog.querySelector('.admin-brand').getBoundingClientRect()
          const close = dialog.querySelector('[data-admin-menu-close]').getBoundingClientRect()
          const nav = dialog.querySelector('nav').getBoundingClientRect()
          const current = dialog.querySelector('a[aria-current="page"]').getBoundingClientRect()
          return panel.width === Math.min(320, innerWidth - 64) && brand.top === 0 && brand.height === 64 &&
            close.left >= panel.right && close.right <= innerWidth && close.width === 44 &&
            current.top >= nav.top && current.bottom <= nav.bottom &&
            document.body.classList.contains('admin-menu-open') && document.documentElement.scrollWidth <= innerWidth
        })()
      JS
      screenshot("navigation-#{width}")
      find("[data-admin-menu-close]").click
      assert_no_selector "#admin-navigation[open]"
      assert_selector "[data-admin-menu-open]:focus"
      click_button "打开管理菜单"
      page.execute_script("document.querySelector('.admin-mobile-menu-panel').click()")
      assert_selector "#admin-navigation[open]"
      page.execute_script("document.elementFromPoint(innerWidth - 4, 100).click()")
      assert_no_selector "#admin-navigation[open]"
      assert_selector "[data-admin-menu-open][aria-expanded='false']:focus"
    end
    click_button "打开管理菜单"
    resize_viewport(1100, 844)
    assert_no_selector "#admin-navigation[open]"
    assert_selector ".admin-sidebar a[aria-current='page']", text: "网站管理员"
    assert_not page.evaluate_script("document.body.classList.contains('admin-menu-open')")
  end

  test "mobile filter selects retain list context and leave links usable without JavaScript" do
    visit admin_works_path(q: "reference-no-match", published: "true", city_id: cities(:city_1).id, per_page: 50, locale: :en, page: 2)
    [320, 390].each do |width|
      resize_viewport(width, 844)
      assert_no_selector ".admin-filter-tabs"
      assert_selector :select, "发布状态", selected: "已发布"
      select "未发布", from: "发布状态"
      assert_selector :select, "发布状态", selected: "未发布"
      query = URI.decode_www_form(URI(page.current_url).query).to_h
      assert_equal({"q" => "reference-no-match", "published" => "false", "city_id" => cities(:city_1).id.to_s, "per_page" => "50", "locale" => "en"}, query)
      assert_field "搜索名称 / 标题", with: "reference-no-match"
      assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
      screenshot("filter-select-#{width}")
      select "已发布", from: "发布状态"
    end
    resize_viewport(640, 844)
    assert_no_selector "[data-admin-filter-select]"
    assert_selector ".admin-filter-tabs a[aria-current='page']", text: "已发布"
    within(".admin-filter-tabs") { click_link "未发布" }
    assert_selector ".admin-filter-tabs a[aria-current='page']", text: "未发布"

    page.driver.browser.execute_cdp("Emulation.setScriptExecutionDisabled", value: true)
    resize_viewport(320, 844)
    visit admin_works_path(published: "true", locale: :en)
    assert_no_selector "[data-admin-filter-select]"
    within(".admin-filter-tabs") { click_link "未发布" }
    assert_selector ".admin-filter-tabs a[aria-current='page']", text: "未发布"
    screenshot("filter-links-without-javascript")
  ensure
    page.driver.browser.execute_cdp("Emulation.setScriptExecutionDisabled", value: false)
  end

  test "page actions details and pagination follow their responsive reference layouts" do
    visit admin_info_path(infos(:info_635), locale: :cn)
    [320, 640, 768, 1400].each do |width|
      resize_viewport(width, 1000)
      assert page.evaluate_script(<<~JS), "Headings and detail cards should match at #{width}px"
        (() => {
          const heading = document.querySelector('.admin-page-heading')
          const title = heading.firstElementChild.getBoundingClientRect()
          const actions = heading.querySelector('.admin-actions').getBoundingClientRect()
          const card = document.querySelector('.admin-description-heading')
          const styles = getComputedStyle(card)
          return styles.paddingTop === '24px' && styles.paddingBottom === '24px' &&
            (innerWidth < 768 ? actions.top >= title.bottom + 15 : actions.left >= title.right + 15) &&
            document.documentElement.scrollWidth <= innerWidth
        })()
      JS
      screenshot("detail-heading-#{width}")
    end
    visit admin_users_path(per_page: 1, locale: :en)
    [320, 390, 640, 1400].each do |width|
      resize_viewport(width, 1000)
      if width < 640
        assert_no_selector ".admin-pagination-summary"
        assert_no_selector ".admin-page-number"
        assert_no_selector ".admin-page-direction svg"
        assert_equal "500", find("a.admin-page-direction").style("font-weight")["font-weight"]
      else
        assert_selector ".admin-pagination-summary", text: "显示 1–1"
        assert_selector ".admin-page-number[aria-current='page']", text: "1"
        assert_selector ".admin-page-direction svg"
      end
      assert_not_equal find("a.admin-page-direction").style("box-shadow")["box-shadow"], find("span.admin-page-direction[aria-disabled='true']").style("box-shadow")["box-shadow"]
      assert page.evaluate_script("document.documentElement.scrollWidth <= innerWidth")
      page.execute_script("document.querySelector('.admin-pagination').scrollIntoView({block: 'center'})")
      screenshot("pagination-#{width}")
    end
    resize_viewport(320, 1000)
    click_link "下一页", exact: true
    assert_selector ".admin-page-number[aria-current='page']", text: "2", visible: :hidden
    assert_includes page.current_url, "locale=en"
    assert_includes page.current_url, "per_page=1"
    click_link "上一页", exact: true
    assert_selector ".admin-page-number[aria-current='page']", text: "1", visible: :hidden
  end

  test "wrapped checkbox choices align with the first text line and retain forced color controls" do
    ProjectType.create!(id: 99601, cn_name: "多行分类 Long project category " * 8, en_name: "Long category")
    visit new_admin_work_path
    checkbox = find('input[name="work[project_type_ids][]"][value="99601"]')
    [320, 640, 1400].each do |width|
      resize_viewport(width, 1000)
      assert page.evaluate_script(<<~JS), "Checkboxes should align with the first line of wrapped labels at #{width}px"
        (() => {
          const checkbox = document.querySelector('input[name="work[project_type_ids][]"][value="99601"]')
          const label = checkbox.closest('label').querySelector('span').getBoundingClientRect()
          const control = checkbox.getBoundingClientRect()
          return label.height > 24 && Math.abs(control.top - label.top - 4) < 1 &&
            control.width === 16 && control.height === 16 && document.documentElement.scrollWidth <= innerWidth
        })()
      JS
      checkbox.check
      page.execute_script("document.querySelector('input[value=\"99601\"][type=\"checkbox\"]').closest('label').scrollIntoView({block: 'center'})")
      screenshot("wrapped-checkbox-#{width}")
    end
    page.execute_script("const checkbox = document.querySelector('input[value=\"99601\"][type=\"checkbox\"]'); checkbox.disabled = true; checkbox.indeterminate = true")
    assert_equal "1", checkbox.style("opacity")["opacity"]
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [{name: "forced-colors", value: "active"}])
    assert_equal "auto", checkbox.style("appearance")["appearance"]
    assert_equal "none", checkbox.style("background-image")["background-image"]
  ensure
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [])
  end

  test "gallery uploads and city roles use the shared responsive field spacing" do
    person = Admin::Person.create!(id: 99601, url_name: "reference-spacing", category: 1)
    CityPerson.create!(id: 99601, person: person, city: cities(:city_1))
    [[new_admin_work_path, "#gallery-heading"], [edit_admin_person_path(person), "#city-roles-heading"]].each do |path, heading|
      visit path
      [390, 640, 1400].each do |width|
        resize_viewport(width, 1000)
        assert page.evaluate_script(<<~JS, heading), "Nested editor fields should use the reference spacing at #{width}px"
          (() => {
            const section = document.querySelector(arguments[0]).closest('section')
            const fields = section.querySelector('.admin-fields')
            const styles = getComputedStyle(fields)
            const first = fields.children[0].getBoundingClientRect()
            const second = fields.children[1].getBoundingClientRect()
            return styles.columnGap === '24px' && styles.rowGap === '32px' &&
              (innerWidth >= 640 ? Math.abs(first.top - second.top) < 1 : second.top >= first.bottom + 31) &&
              document.documentElement.scrollWidth <= innerWidth
          })()
        JS
        page.execute_script("document.querySelector(arguments[0]).scrollIntoView({block: 'start'})", heading)
        screenshot("#{heading.delete_prefix("#")}-#{width}")
      end
    end
  end
end
