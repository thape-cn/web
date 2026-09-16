# frozen_string_literal: true

require "application_system_test_case"

class Admin::RichTextTest < ApplicationSystemTestCase
  setup do
    Admin::User.create!(id: 99003, name: "Editor", email: "editor@example.test", password: "browser-test-password")
    visit admin_login_path
    fill_in "邮箱", with: "editor@example.test"
    fill_in "密码", with: "browser-test-password"
    click_button "登录"
    assert_selector "h1", text: "网站管理"
  end

  test "rich text renders legacy HTML and saves formatting while retaining plain text fields" do
    info = Admin::Info.find(infos(:info_635).id)
    Globalize.with_locale(:cn) do
      info.update!(introduction: "Original introduction\nSecond line", content: '<p style="text-align: center;"><span style="font-size: 15px; color: rgb(136, 136, 136);">Legacy content</span></p><p><a href="https://example.test/article">Existing link</a></p><p><img src="/favicon.ico" alt="Existing image" width="32" height="32"></p>')
    end
    visit edit_admin_info_path(info, locale: :cn)
    assert_selector ".simditor-body", count: 1
    assert_selector "textarea#info_introduction"
    assert_no_selector "textarea#info_content", visible: true
    assert_selector '.simditor-body p[style*="text-align: center"]', text: "Legacy content"
    assert_selector '.simditor-body a[href="https://example.test/article"]', text: "Existing link"
    assert_selector '.simditor-body img[alt="Existing image"]'

    content = find('[role="textbox"][aria-labelledby="info_content_label"]')
    content.click
    modifier = page.evaluate_script("navigator.platform.includes('Mac')") ? :command : :control
    content.send_keys([modifier, "a"])
    find(".toolbar-item-bold").click
    assert_selector ".simditor-body b, .simditor-body strong", text: "Legacy content"
    content.send_keys(:right, " appended")
    click_button "保存"
    assert_text "保存成功"

    Globalize.with_locale(:cn) do
      info.reload
      assert_equal ["Original introduction", "Second line"], info.introduction.split(/\r?\n/)
      assert_match(/<(b|strong)[ >]/, info.content)
      assert_includes info.content, "appended"
      assert_includes info.content, 'href="https://example.test/article"'
      assert_includes info.content, 'alt="Existing image"'
    end

    visit edit_admin_info_path(info, locale: :cn)
    page.execute_script("document.querySelector('.simditor').scrollIntoView({block: 'center'})")
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/simditor-desktop.png")) # standard:disable Lint/Debugger
    resize_viewport(390, 844)
    page.execute_script("document.querySelector('.simditor').scrollIntoView({block: 'center'})")
    assert page.evaluate_script("document.documentElement.scrollWidth <= window.innerWidth"), "Mobile editors should not overflow horizontally"
    page.save_screenshot(Rails.root.join("tmp/screenshots/admin/simditor-mobile.png")) # standard:disable Lint/Debugger
  end

  test "other rich text forms use Simditor while plain text forms and public pages stay unchanged" do
    [new_admin_person_path, new_admin_case_path].each do |path|
      visit path
      assert_selector ".simditor-body", count: 1
      assert_no_selector "textarea[data-admin-rich-text]", visible: true
    end

    [new_admin_work_path, edit_admin_service_file_path(1), admin_seos_path].each do |path|
      visit path
      assert_selector "textarea"
      assert_no_selector ".simditor"
    end

    visit root_path
    assert_no_selector ".simditor"
    assert page.evaluate_script("typeof window.jQuery === 'undefined'")
    assert_no_selector 'script[src*="simditor"], script[src*="admin"]', visible: :all
  end

  test "the image toolbar uploads a file and saves its URL in the content" do
    # The checked-in database snapshot omits the pictures ID default.
    connection = Picture.connection
    unless connection.pk_and_sequence_for("pictures")&.last
      connection.execute("CREATE TEMP SEQUENCE editor_picture_ids START WITH #{Picture.maximum(:id).to_i + 1}")
      connection.execute("ALTER TABLE pictures ALTER COLUMN id SET DEFAULT nextval('editor_picture_ids')")
    end

    info = Admin::Info.find(infos(:info_635).id)
    Globalize.with_locale(:cn) { info.update!(introduction: "Upload introduction", content: "<p>Image upload test</p>") }
    file = Tempfile.new(["editor-upload", ".png"])
    file.binmode
    file.write(Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aXioAAAAASUVORK5CYII="))
    file.close

    visit edit_admin_info_path(info, locale: :cn)
    find(".simditor-body").click
    find(".toolbar-item-image").click
    within(".menu-item-upload-image") { attach_file file.path, make_visible: true }
    assert_selector '.simditor-body img[src*="/uploads/picture/image/"]'
    picture = Picture.order(:id).last
    assert_selector ".simditor-body img:not(.uploading)"
    click_button "保存"
    assert_text "保存成功"
    Globalize.with_locale(:cn) { assert_includes info.reload.content, picture.image.url }
  ensure
    picture&.image&.remove!
    file&.unlink
  end
end
