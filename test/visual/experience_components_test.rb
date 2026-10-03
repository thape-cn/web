# frozen_string_literal: true

require_relative "mobile_overlays_test"
return unless defined?(PublicComponentsTest)

class PublicComponentsTest
  def test_about_disclosure_preserves_links_and_keyboard_navigation
    %i[cn en].each do |locale|
      visit_experience("/work/#{locale}", 1340)
      page.find(".thape-header .logo").hover
      page.find(".work-carousel-rotation").hover
      trigger = page.find("#about-nav-link")
      assert_equal "/about", URI(trigger[:href]).path
      assert_no_selector "#about-nav"
      page.find(".logo a").send_keys(:tab)
      assert_selector "#about-nav-link:focus[aria-expanded='true']"
      assert_selector "#about-nav"
      links = page.all("#about-nav a")
      assert_equal %w[/about /culture /leadership /leadership/shanghai], links.map { |link| URI(link[:href]).path }
      trigger.send_keys(:tab)
      links.each do |link|
        assert link.evaluate_script("this === document.activeElement")
        link.send_keys(:tab)
      end
      assert_selector ".menu-nav > .nav-item > a[href='/works']:focus"
      assert_no_selector "#about-nav"
      page.find(".menu-nav > .nav-item > a[href='/works']").send_keys([:shift, :tab])
      trigger.send_keys(:arrow_down)
      assert links.first.evaluate_script("this === document.activeElement")
      links.first.send_keys(:escape)
      assert_selector "#about-nav-link:focus[aria-expanded='false']"
      assert_no_selector "#about-nav"
      trigger.hover
      assert_selector "#about-nav"
      trigger.send_keys(:arrow_down)
      links.first.send_keys(:escape)
      assert_no_selector "#about-nav"
      trigger.send_keys(:tab)
      assert_selector ".menu-nav > .nav-item > a[href='/works']:focus"
      @measurements << {locale: locale, about_links: links.size, keyboard: "Tab, ArrowDown, Escape, mouse hover"}
    end
  end

  def test_work_carousel_controls_rotation_focus_and_repeated_input
    %i[cn en].each do |locale|
      visit_experience("/work/#{locale}", 1340)
      previous = page.find(".work-carousel .action-left", visible: :all)
      following = page.find(".work-carousel .action-right", visible: :all)
      rotation = page.find(".work-carousel-rotation")
      assert_equal "button", previous.tag_name
      assert_equal "button", following.tag_name
      assert_equal I18n.t("work_carousel.previous", locale: locale), previous[:"aria-label"]
      assert_equal I18n.t("work_carousel.next", locale: locale), following[:"aria-label"]
      assert_equal 5000, carousel_state["interval"]
      page.find(".thape-header .logo").hover
      @measurements << {initial_carousel: carousel_state}
      assert carousel_state["running"]
      # Observe one real five-second automatic advance.
      Selenium::WebDriver::Wait.new(timeout: 7).until { carousel_state["index"] == 1 }
      rotation.send_keys(:tab)
      assert previous.evaluate_script("this === document.activeElement")
      assert carousel_state["paused"]
      refute carousel_state["running"]
      assert_equal "1", previous.evaluate_script("getComputedStyle(this).opacity")
      assert_operator previous.evaluate_script("parseFloat(getComputedStyle(this).outlineWidth)"), :>, 0
      sleep 0.55
      previous.send_keys(:enter)
      wait_for_slide(0)
      previous.send_keys(:tab)
      assert following.evaluate_script("this === document.activeElement")
      following.send_keys(:space)
      wait_for_slide(1)
      following.send_keys(:enter)
      wait_for_slide(2)
      following.send_keys(:enter)
      wait_for_slide(0)
      # Rapid clicks must leave exactly one current slide when the fade ends.
      page.execute_script("for (let i=0;i<5;i++) document.querySelector('.work-carousel .action-right').click()")
      wait_for_slide(1)
      assert_selector ".work-carousel .image-item.active", count: 1
      assert_selector ".work-carousel [aria-hidden='false']", count: 1
      assert following.evaluate_script("this === document.activeElement")
      rotation.click
      assert carousel_state["hovered"]
      refute carousel_state["paused"]
      refute carousel_state["running"]
      page.find(".thape-header .logo").hover
      assert carousel_state["running"]
      rotation.click
      page.find(".thape-header .logo").hover
      assert carousel_state["paused"]
      refute carousel_state["running"]
      page.save_screenshot(@output.join("work-carousel-#{locale}-desktop.png")) # standard:disable Lint/Debugger
      @measurements << {locale: locale, carousel: carousel_state}
      controller = page.evaluate_script("window.web_app.getControllerForElementAndIdentifier(document.querySelector('.work-carousel'),'work-carousel').index")
      assert_equal 1, controller
    end
  end

  def test_work_carousel_reduced_motion_touch_and_single_image
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [{name: "prefers-reduced-motion", value: "reduce"}])
    [320, 390].each do |width|
      visit_experience("/work/en", width)
      assert carousel_state["reduced"]
      assert carousel_state["paused"]
      refute carousel_state["running"]
      following = page.find(".work-carousel .action-right")
      rect = following.evaluate_script("this.getBoundingClientRect().toJSON()")
      assert_operator rect["width"], :>=, 44
      tap(rect["x"] + rect["width"] / 2, rect["y"] + rect["height"] / 2)
      assert_equal 1, carousel_state["index"]
      assert_no_selector ".work-carousel .animate"
      assert_operator page.evaluate_script("document.documentElement.scrollWidth - innerWidth"), :<=, 1
      page.save_screenshot(@output.join("work-carousel-en-#{width}.png")) # standard:disable Lint/Debugger
    end
    visit_experience("/work/single", 390)
    assert_selector ".work-carousel .image-item.active", count: 1
    assert_no_selector ".work-carousel button"
    refute carousel_state["running"]
    visit_experience("/work/en", 390)
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [{name: "prefers-reduced-motion", value: "no-preference"}])
    settle
    refute carousel_state["running"], "Changing preferences must not restart a paused carousel"
    page.find(".work-carousel-rotation").click
    @measurements << {resumed_mobile_carousel: carousel_state}
    assert carousel_state["running"]
    page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [{name: "prefers-reduced-motion", value: "reduce"}])
    settle
    Selenium::WebDriver::Wait.new(timeout: 2).until { carousel_state["paused"] }
    refute carousel_state["running"]
    page.execute_script("window.detachedCarousel = window.web_app.getControllerForElementAndIdentifier(document.querySelector('.work-carousel'),'work-carousel'); document.querySelector('.work-carousel').remove()")
    assert_nil page.evaluate_script("window.detachedCarousel.timer")
  end

  def test_building_typography_and_project_link_in_both_font_modes
    %i[cn en].each do |locale|
      %w[sm big].each do |size|
        [320, 390, 1340, 1440].each do |width|
          visit_experience("/building/#{locale}/#{size}", width)
          copy = page.find(".building-service-copy")
          sizes = (size == "big") ? [20, 22] : [16, 18]
          expected_size = sizes[(width < 1024) ? 0 : 1]
          assert_equal expected_size, copy.evaluate_script("parseFloat(getComputedStyle(this).fontSize)")
          assert_in_delta expected_size * 1.8, copy.evaluate_script("parseFloat(getComputedStyle(this).lineHeight)"), 0.1
          assert_operator copy.rect.width / expected_size, :<=, 38
          assert_equal BUILDING_COPY.fetch(locale).map(&:strip), copy.all("p").map(&:text)
          link = page.find(".building-project-link")
          assert_equal "/works", URI(link[:href]).path
          assert_equal I18n.t("services.building.projects_link", locale: locale), link.find("span", match: :first).text
          assert_operator link.rect.height, :>=, 44
          %w[.building-service-heading .building-service-copy .building-project-link].each do |selector|
            assert_operator page.find(selector).evaluate_script("this.scrollWidth - this.clientWidth"), :<=, 1
          end
          assert_operator page.evaluate_script("document.documentElement.scrollWidth - innerWidth"), :<=, 1
          assert_equal((locale == :cn) ? "zh-CN" : "en", page.find("html", visible: :all)[:lang])
          @measurements << {locale: locale, size: size, width: width, font_size: expected_size, copy_width: copy.rect.width, link_height: link.rect.height}
        end
      end
    end
  end

  private

  BUILDING_COPY = {
    cn: ["固定样本：本段仅用于真实模板排版测试，不代表企业业务文案。" * 5, "固定样本：第二段用于检查段落间距及大、小字号。"],
    en: ["Fixed sample for the real architecture template; this is not company copy. " * 5, "A second sample paragraph checks spacing and both font preferences."]
  }.freeze

  def visit_experience(path, width)
    set_viewport(width, height: (width < 640) ? 844 : 1000)
    page.visit(path)
    settle
    if path.start_with?("/work/")
      Selenium::WebDriver::Wait.new(timeout: 5).until do
        page.evaluate_script("!!window.web_app?.getControllerForElementAndIdentifier(document.querySelector('.work-carousel'), 'work-carousel')")
      end
    end
  end

  def carousel_state
    page.evaluate_script(<<~JS)
      (() => { const c = window.web_app.getControllerForElementAndIdentifier(document.querySelector('.work-carousel'), 'work-carousel'); return { index:c.index, paused:c.paused, hovered:c.hovered, running:!!c.timer, reduced:c.motion.matches, interval:c.intervalValue, transitioning:c.transitioning }; })()
    JS
  end

  def wait_for_slide(index)
    Selenium::WebDriver::Wait.new(timeout: 3).until { carousel_state["index"] == index && !carousel_state["transitioning"] }
  end

  def experience_pages
    pages = {}
    %i[cn en].each do |locale|
      pages["/work/#{locale}"] = render_experience(locale, "work")
      %w[sm big].each { |size| pages["/building/#{locale}/#{size}"] = render_experience(locale, "building", size: size) }
    end
    pages["/work/single"] = render_experience(:en, "work", count: 1)
    pages
  end

  def render_experience(locale, type, size: "sm", count: 3)
    controller = (type == "work") ? WorksController.new : ServicesController.new
    controller.request = ActionDispatch::Request.new(Rack::MockRequest.env_for("/#{type}", "HTTP_COOKIE" => "ts=#{size}"))
    controller.response = ActionDispatch::Response.new
    controller.action_name = (type == "work") ? "show" : "building"
    controller.instance_variable_set(:@seo, OpenStruct.new(home_title: "Fixed sample", description: "Fixed sample", abstract: "Fixed sample", keywords: "Fixed sample"))
    cities = Object.new
    %i[where select order].each { |method| cities.define_singleton_method(method) { |*| self } }
    cities.define_singleton_method(:group_by) { |&| {} }
    I18n.with_locale(locale) do
      City.stub(:with_published_works, cities) do
        if type == "work"
          pictures = %w[residential-1.jpg building.jpg contact.jpg].first(count).map do |filename|
            asset = controller.view_context.asset_pack_path("static/images/#{filename}")
            uploader = Object.new
            uploader.define_singleton_method(:url) { |*| asset }
            OpenStruct.new(album_jpg: uploader)
          end
          work = OpenStruct.new(id: 327, project_name: "固定样本 / Fixed sample", work_pictures: pictures, project_types: [], client: "Fixed sample", city: OpenStruct.new(name: "上海", url_name: "shanghai"), snapshot_jpg: pictures.first.album_jpg)
          %i[work first_work second_work previous_work next_work].each { |key| controller.instance_variable_set(:"@#{key}", work) }
          controller.instance_variable_set(:@relative_works, [work] * 4)
          view = controller.view_context
          # Avoid token refresh and external calls while rendering the entire real work template.
          view.define_singleton_method(:wechat_config_js) { |*| "" }
          view.render(template: "works/show", layout: "layouts/application")
        else
          controller.view_context.render(template: "services/building", layout: "layouts/application", locals: {
            background_img: I18n.t("services.building.background_img"),
            chinese_title: I18n.t("services.building.chinese_title"), english_title: I18n.t("services.building.english_title"),
            ps: BUILDING_COPY.fetch(locale), link_site_url: "/works", link_site_title: I18n.t("services.building.projects_link")
          })
        end
      end
    end
  end
end
