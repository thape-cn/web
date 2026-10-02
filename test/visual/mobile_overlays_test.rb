# frozen_string_literal: true

require_relative "public_components_test"

class PublicComponentsTest
  def test_contact_labels_fit_both_languages_on_mobile_and_desktop
    %i[cn en].each do |locale|
      [320, 390, 1340].each do |width|
        visit_overlays(locale, width)
        assert_equal((locale == :cn) ? "zh-CN" : "en", page.find("html", visible: :all)[:lang])
        methods = page.find(".contact-methods")
        assert_equal((width < 640 && locale == :en) ? [] : %w[总机 市场热线 媒体 项目合作], methods.all("h1").map(&:text))
        assert_equal((width < 640 && locale == :cn) ? [] : %w[SWITCHBOARD SERVICE MEDIA PROJECT], methods.all("h2").map(&:text))
        assert_equal(locale == :en, methods.evaluate_script("this.matches(':lang(en)')"))
        assert_equal(locale == :en, page.find(".thape-header").evaluate_script("this.matches(':lang(en)')"))
        if width >= 640
          assert_equal "absolute", methods.evaluate_script("getComputedStyle(this).position")
          rows = methods.all(".contact-method")
          rows.each_cons(2) do |left, right|
            assert_operator left.rect.x + left.rect.width, :<=, right.rect.x + 1
            assert_in_delta left.rect.width, right.rect.width, 1
          end
        end
        if locale == :en && width < 640
          methods.all("h2").each { |label| assert_in_delta label.evaluate_script("parseFloat(getComputedStyle(this).lineHeight)"), label.rect.height, 1 }
        end
        methods.all(".contact-method").each do |row|
          assert_operator row.evaluate_script("this.scrollWidth - this.clientWidth"), :<=, 1
          row.all("h1, h2, p").each do |item|
            assert_operator item.evaluate_script("this.scrollWidth - this.clientWidth"), :<=, 1
          end
        end
        assert_operator page.evaluate_script("document.documentElement.scrollWidth - innerWidth"), :<=, 1
        @measurements << {locale: locale, width: width, language: page.find("html", visible: :all)[:lang], visible_labels: methods.all("h1, h2").map(&:text), overflow: methods.evaluate_script("this.scrollWidth - this.clientWidth")}
        page.execute_script("window.scrollTo(0, document.querySelector('#contact-sample').offsetTop)")
        settle
        page.save_screenshot(@output.join("contact-labels-#{locale}-#{width}.png")) # standard:disable Lint/Debugger
      end
    end
  end

  def test_mobile_menu_locks_background_and_scrolls_long_contents
    %i[cn en].each do |locale|
      visit_overlays(locale, 320, height: 568)
      page.execute_script("window.scrollTo(0, 280)")
      original = scroll_state
      2.times do
        page.find(".aside-menu-button").click
        assert_selector ".aside-menu.show"
        assert_equal "fixed", body_position
        %w[1 3].each { |index| page.find(".aside-menu-container > .aside-menu-item:nth-child(#{index}) > a").click }
        menu = page.find(".aside-menu")
        assert_operator menu.evaluate_script("this.scrollHeight - this.clientHeight"), :>, 0
        top = body_top
        swipe(260, 440, 170)
        assert_in_delta top, body_top, 1
        assert_operator menu.evaluate_script("this.scrollTop"), :>, 0
        page.save_screenshot(@output.join("mobile-menu-#{locale}-320.png")) # standard:disable Lint/Debugger
        page.find(".aside-menu-button").click
        assert_no_selector ".aside-menu.show"
        assert_restored original
        # Collapse the retained groups before the next repeated open.
        if it == 0
          page.find(".aside-menu-button").click
          %w[1 3].each { |index| page.find(".aside-menu-container > .aside-menu-item:nth-child(#{index}) > a").click }
          page.find(".aside-menu-button").click
        end
      end
      page.find(".aside-menu-button").click
      page.find("button[data-action='click->header#showMobileSearch']").click
      assert_no_selector ".aside-menu.show"
      assert_selector ".mobile-search.show"
      assert_equal "fixed", body_position
      page.find("button[data-action='click->header#hideMobileSearch']").click
      assert_restored original
      visit_overlays(locale, 390)
      page.find(".aside-menu-button").click
      %w[1 3].each { |index| page.find(".aside-menu-container > .aside-menu-item:nth-child(#{index}) > a").click }
      settle
      page.save_screenshot(@output.join("mobile-menu-#{locale}-390.png")) # standard:disable Lint/Debugger
      page.find(".aside-menu-button").click
      assert_unlocked
    end
  end

  def test_company_dialog_keeps_content_clicks_and_links_open_and_restores_scroll
    %i[cn en].each do |locale|
      visit_overlays(locale, 390)
      opener = page.find("#office-sample [data-biz-map-target='company']")
      page.scroll_to(opener, align: :center)
      original = scroll_state
      opener.click
      dialog = page.find(".mobile-company-panel")
      @measurements << {original: original, locked_body_top: body_top}
      assert_equal "fixed", body_position
      assert_selector ".company-panel-close:focus"
      dialog.find("h1", match: :first).click
      assert_selector ".mobile-company-panel"
      # An in-document sample link exercises bubbling without calling an external service.
      dialog.find("a", match: :first).click
      assert_selector ".mobile-company-panel"
      content = dialog.find(".company-panel-content")
      assert_operator content.evaluate_script("this.scrollHeight - this.clientHeight"), :>, 0
      assert_operator content.evaluate_script("this.scrollWidth - this.clientWidth"), :<=, 1
      top = body_top
      swipe(285, 685, 285)
      assert_in_delta top, body_top, 1
      assert_operator content.evaluate_script("this.scrollTop"), :>, 0
      assert_operator dialog.find(".company-panel-close").evaluate_script("this.getBoundingClientRect().top"), :>=, 0
      page.save_screenshot(@output.join("company-dialog-#{locale}-390.png")) # standard:disable Lint/Debugger
      dialog.find(".company-panel-close").click
      assert_no_selector ".mobile-company-panel"
      assert_restored original
      assert opener.evaluate_script("this === document.activeElement")

      page.scroll_to(opener, align: :center)
      original = scroll_state
      opener.click
      tap(5, 420)
      assert_no_selector ".mobile-company-panel"
      assert_restored original
      page.scroll_to(opener, align: :center)
      original = scroll_state
      opener.click
      page.find(".company-panel-close").send_keys(:escape)
      assert_no_selector ".mobile-company-panel"
      assert_restored original
    end
  end

  def test_stacked_overlays_restore_original_styles_only_after_the_last_close
    visit_overlays(:en, 390)
    page.execute_script(<<~JS)
      document.body.style.setProperty('position', 'relative', 'important');
      document.body.style.setProperty('overflow', 'auto', 'important');
      document.body.style.paddingRight = '7px';
      document.documentElement.style.overflow = 'auto';
      window.scrollTo(0, 280);
      document.documentElement.style.scrollBehavior = 'smooth';
    JS
    original = scroll_state
    modal_call("open({currentTarget: document.querySelector('[data-action=\"modal#open\"]')})")
    modal_call("open({currentTarget: document.querySelector('[data-action=\"modal#open\"]')})")
    company_call("selectCompany({type: 'click', currentTarget: document.querySelector('[data-biz-map-target=company]')})")
    assert_selector ".mobile-company-panel"
    modal_call("close(false)")
    assert_equal "fixed", body_position
    assert_selector ".mobile-company-panel"
    company_call("closeCompany()")
    assert_restored original
    @measurements << {stacked_overlays: "background stays locked after lower overlay closes", restored: original}
  end

  def test_overlay_locks_are_released_on_cache_navigation_disconnect_and_resize
    ["turbo:before-cache", "turbolinks:before-cache", "pagehide"].each do |event|
      visit_overlays(:en, 390)
      page.execute_script("window.scrollTo(0, 220)")
      original = scroll_state
      page.find(".aside-menu-button").click
      modal_call("open({currentTarget: document.querySelector('[data-action=\"modal#open\"]')})")
      company_call("selectCompany({type: 'click', currentTarget: document.querySelector('[data-biz-map-target=company]')})")
      page.execute_script("#{(event == "pagehide") ? "window" : "document"}.dispatchEvent(new Event(arguments[0]))", event)
      assert_no_selector ".aside-menu.show, .mobile-company-panel, #project-message-dialog"
      assert_restored original
    end

    visit_overlays(:en, 390)
    page.find(".aside-menu-button").click
    set_viewport(1340)
    assert_unlocked
    assert_no_selector ".aside-menu.show"
    set_viewport(390)
    company_call("selectCompany({type: 'click', currentTarget: document.querySelector('[data-biz-map-target=company]')})")
    set_viewport(1340)
    assert_unlocked
    assert_no_selector ".mobile-company-panel"
    page.find("#office-sample [data-biz-map-target=company]").click
    assert_unlocked

    visit_overlays(:en, 390)
    company_call("selectCompany({type: 'click', currentTarget: document.querySelector('[data-biz-map-target=company]')})")
    page.execute_script("document.querySelector('#office-sample').remove()")
    assert_unlocked
    page.find(".aside-menu-button").click
    page.execute_script("document.querySelector('.thape-header').remove()")
    assert_unlocked

    visit_overlays(:cn, 390)
    page.find(".aside-menu-button").click
    page.find(".aside-menu a[href='?locale=en']").click
    assert_no_selector ".aside-menu.show"
    assert_unlocked
  end

  private

  def visit_overlays(locale, width, height: 844)
    set_viewport(width, height: height)
    page.visit("/overlays/#{locale}")
    assert_selector "#contact-sample"
    settle
    @measurements << page.evaluate_script("({width: innerWidth, height: innerHeight, dpr: devicePixelRatio, touch: navigator.maxTouchPoints, ua: navigator.userAgent})")
  end

  def set_viewport(width, height: 844)
    browser = page.driver.browser
    mobile = width < 640
    @desktop_ua ||= page.evaluate_script("navigator.userAgent")
    browser.execute_cdp("Emulation.setDeviceMetricsOverride", width: width, height: height, deviceScaleFactor: mobile ? 3 : 1, mobile: mobile)
    browser.execute_cdp("Emulation.setTouchEmulationEnabled", enabled: mobile)
    browser.execute_cdp("Network.setUserAgentOverride", userAgent: mobile ? "Mozilla/5.0 (Linux; Android 15; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Mobile Safari/537.36" : @desktop_ua)
  end

  def settle
    page.evaluate_async_script("const done = arguments[0]; document.fonts.ready.then(() => setTimeout(() => done(true), 350))")
  end

  def body_position
    page.evaluate_script("getComputedStyle(document.body).position")
  end

  def body_top
    page.evaluate_script("document.body.getBoundingClientRect().top")
  end

  def scroll_state
    page.evaluate_script("({x: scrollX, y: scrollY, body: document.body.style.cssText, root: document.documentElement.style.cssText})")
  end

  def assert_restored(original)
    current = scroll_state
    assert_in_delta original["x"], current["x"], 1
    assert_in_delta original["y"], current["y"], 1
    assert_equal original["body"], current["body"]
    assert_equal original["root"], current["root"]
  end

  def assert_unlocked
    Selenium::WebDriver::Wait.new(timeout: 3).until { body_position != "fixed" }
    refute_equal "hidden", page.evaluate_script("getComputedStyle(document.documentElement).overflow")
  end

  def modal_call(method)
    page.execute_script("window.web_app.getControllerForElementAndIdentifier(document.querySelector('#contact-sample'), 'modal').#{method}")
  end

  def company_call(method)
    page.execute_script("window.web_app.getControllerForElementAndIdentifier(document.querySelector('#office-sample'), 'biz-map').#{method}")
  end

  def tap(x, y)
    browser = page.driver.browser
    browser.execute_cdp("Input.dispatchTouchEvent", type: "touchStart", touchPoints: [{x: x, y: y}])
    browser.execute_cdp("Input.dispatchTouchEvent", type: "touchEnd", touchPoints: [])
  end

  def swipe(x, from, to)
    browser = page.driver.browser
    browser.execute_cdp("Input.dispatchTouchEvent", type: "touchStart", touchPoints: [{x: x, y: from}])
    10.times do |index|
      browser.execute_cdp("Input.dispatchTouchEvent", type: "touchMove", touchPoints: [{x: x, y: from + (to - from) * (index + 1) / 10.0}])
      sleep 0.04
    end
    browser.execute_cdp("Input.dispatchTouchEvent", type: "touchEnd", touchPoints: [])
    settle
  end
end
