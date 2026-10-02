# frozen_string_literal: true

# Standalone, fixture-free browser checks. See test/visual/README.md.
ENV["RAILS_ENV"] ||= "test"
raise "Use the isolated in-memory database" unless ENV["RAILS_ENV"] == "test" && ENV["DATABASE_URL"] == "sqlite3::memory:"
require_relative "../../config/environment"
require "minitest/autorun"
require "minitest/mock"
require "capybara/minitest"
require "selenium-webdriver"
require "ostruct"
require "net/http"
require "tmpdir"

class PublicComponentsTest < Minitest::Test
  include Capybara::Minitest::Assertions

  TITLES = [
    "天华作品 | 天津奥林匹克大厦「成都道126号」",
    "TIANHUA Architecture 2026 Residential Design",
    "连续中文标题用于验证窄卡片中的自然换行与完整显示",
    "Architecture" * 8
  ].freeze

  def setup
    @output = Rails.root.join("tmp/visual-quality")
    FileUtils.mkdir_p(@output)
    @sql = []
    @measurements = []
    @subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") { |*event| @sql << event.last[:sql] }
    public_root = ENV.fetch("VISUAL_PUBLIC_ROOT", Rails.root.join("public").to_s)
    static = Rack::Files.new(public_root)
    pages = %i[cn en].flat_map { |locale| [["/#{locale}", render_sample(locale)], ["/overlays/#{locale}", render_sample(locale, overlays: true)]] }.to_h
    app = lambda do |env|
      next [405, {}, []] unless %w[GET HEAD].include?(env["REQUEST_METHOD"])
      html = pages[env["PATH_INFO"]]
      html ? [200, {"content-type" => "text/html; charset=utf-8"}, [html]] : static.call(env)
    end
    Capybara.register_driver :public_visual do |rack_app|
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--headless=new") unless ENV["HEADED"] == "1"
      options.add_argument("--window-size=1440,1100")
      options.add_argument("--disable-background-networking")
      @profile = Dir.mktmpdir("thape-visual-chrome-")
      options.add_argument("--user-data-dir=#{@profile}")
      service = ENV["CHROMEDRIVER"] && Selenium::WebDriver::Chrome::Service.new(path: ENV.fetch("CHROMEDRIVER"))
      Capybara::Selenium::Driver.new(rack_app, browser: :chrome, options: options, service: service)
    end
    Capybara.server = :puma, {Silent: true}
    @page = Capybara::Session.new(:public_visual, app)
    guard_browser_requests
  end

  def teardown
    unless passed?
      page.save_screenshot(@output.join("#{name}-failure.png")) # standard:disable Lint/Debugger
      @measurements << page.evaluate_script(<<~JS)
        ({width: innerWidth, height: innerHeight, scrollY, elements: [...document.querySelectorAll('body, .aside-menu, .aside-menu-container, .mobile-company-panel, .company-panel-content')].map(e => ({class: e.className, rect: e.getBoundingClientRect().toJSON(), scrollHeight: e.scrollHeight, clientHeight: e.clientHeight, position: getComputedStyle(e).position, overflow: getComputedStyle(e).overflow, maxHeight: getComputedStyle(e).maxHeight, display: getComputedStyle(e).display}))})
      JS
    end
    assert_empty @sql, "Component rendering must not query a database"
    assert_empty @requests.reject { |request| request[:allowed] }, "Browser must only request local GET/HEAD resources"
    File.write(@output.join("#{name}.json"), JSON.pretty_generate({sql_queries: @sql, measurements: @measurements, requests: @requests}))
    ActiveSupport::Notifications.unsubscribe(@subscriber)
    page&.driver&.quit
    @socket&.close
    FileUtils.remove_entry(@profile) if @profile && File.directory?(@profile)
  end

  attr_reader :page

  def test_navigation_normal_hover_and_current_contrast
    %i[cn en].each do |locale|
      visit_sample(locale, 1440)
      normal = page.find(".menu-nav > .nav-item > a:not(.active)", match: :first)
      current = page.find(".menu-nav > .nav-item > a.active")
      normal_color = normal.evaluate_script("getComputedStyle(this).color")
      current_color = current.evaluate_script("getComputedStyle(this).color")
      assert_operator contrast_on_white(normal_color), :>=, 4.5
      assert_operator contrast_on_white(current_color), :>=, 4.5
      @measurements << {locale: locale, normal_color: normal_color, normal_contrast: contrast_on_white(normal_color), current_color: current_color, current_contrast: contrast_on_white(current_color)}
      refute_equal normal_color, current_color
      normal.hover
      assert_equal current_color, normal.evaluate_script("getComputedStyle(this).color")
      page.find("main").hover
      assert_equal normal_color, normal.evaluate_script("getComputedStyle(this).color")
      page.save_screenshot(@output.join("components-#{locale}-desktop.png")) # standard:disable Lint/Debugger
    end
  end

  def test_news_wraps_words_and_numbers_without_overflow
    [1440, 1340, 1024, 768, 640, 390].each do |width|
      visit_sample(:cn, width)
      titles = page.all(".card-title-mask p[title]")
      assert_equal 4, titles.size
      if width >= 640
        titles.each do |title|
          assert_operator title.evaluate_script("this.scrollWidth - this.clientWidth"), :<=, 1
        end
        assert_equal "normal", titles.first.evaluate_script("getComputedStyle(this).wordBreak")
        assert_equal 1, token_line_count(titles.first, "126")
        assert_equal 1, token_line_count(titles[1], "Architecture")
        assert_operator titles[2].rect.height, :>, 24
        @measurements << {width: width, number_lines: token_line_count(titles.first, "126"), word_lines: token_line_count(titles[1], "Architecture")}
      else
        assert_equal "nowrap", titles.first.evaluate_script("getComputedStyle(this).whiteSpace")
        assert_equal "ellipsis", titles.first.evaluate_script("getComputedStyle(this).textOverflow")
        page.save_screenshot(@output.join("components-cn-mobile.png")) # standard:disable Lint/Debugger
      end
      assert_operator page.evaluate_script("document.documentElement.scrollWidth - innerWidth"), :<=, 1
    end
  end

  def test_social_icons_align_and_qr_hover_and_focus_still_work
    [1440, 1340, 768, 390].each do |width|
      visit_sample(:cn, width)
      icons = page.all(".footer-social a img, .footer-social button img")
      assert_equal 6, icons.size
      tops = icons.map { |icon| icon.rect.y }
      assert_operator tops.max - tops.min, :<=, 0.5
      @measurements << {width: width, icon_tops: tops, icon_heights: icons.map { |icon| icon.rect.height }}
      icons.each { |icon| assert_in_delta((width >= 768) ? 24 : 16, icon.rect.height, 0.5) }
      %w[wechat shipinhao xiaohongshu].each do |network|
        button = page.find("button[aria-describedby='#{network}-qr']")
        page.find("main").hover
        assert_no_selector "##{network}-qr"
        button.hover
        assert_selector "##{network}-qr"
        button.send_keys(:space)
        page.find("main").hover
        assert_selector "##{network}-qr"
        button.send_keys(:tab)
        assert_no_selector "##{network}-qr"
      end
    end
  end

  def test_service_links_are_reachable_by_keyboard_and_dismiss_with_escape
    %i[cn en].each do |locale|
      [1340, 1024].each do |width|
        visit_sample(locale, width)
        page.find("main").hover
        trigger = page.find("#service-nav-link")
        assert_equal "/building", URI(trigger[:href]).path
        assert_no_selector "#service-nav"
        page.find(".menu-nav > .nav-item > a.active").send_keys(:tab)
        assert_selector "#service-nav-link:focus[aria-expanded='true']"
        assert_selector "#service-nav"
        links = page.all("#service-nav a")
        assert_equal 7, links.size
        assert_no_selector "#service-nav [role='menuitem']"
        trigger.send_keys(:tab)
        links.each_with_index do |link, index|
          assert link.evaluate_script("this === document.activeElement"), "Tab should reach service link #{index + 1}"
          link.send_keys(:tab)
        end
        assert_selector ".menu-nav > .nav-item > a[href='/news']:focus"
        assert_selector "#service-nav-link[aria-expanded='false']"
        assert_no_selector "#service-nav"

        page.find(".menu-nav > .nav-item > a[href='/news']").send_keys([:shift, :tab])
        assert_selector "#service-nav-link:focus"
        trigger.send_keys(:arrow_down)
        assert links.first.evaluate_script("this === document.activeElement")
        if width == 1340
          page.save_screenshot(@output.join("service-keyboard-#{locale}.png")) # standard:disable Lint/Debugger
        end
        links.first.send_keys([:shift, :tab])
        assert_selector "#service-nav-link:focus"
        trigger.send_keys(:arrow_down)
        links.first.send_keys(:escape)
        assert_selector "#service-nav-link:focus[aria-expanded='false']"
        assert_no_selector "#service-nav"
        trigger.send_keys(:tab)
        assert_selector ".menu-nav > .nav-item > a[href='/news']:focus"

        trigger.hover
        assert_selector "#service-nav"
        assert_selector "#service-nav-link[aria-expanded='true']"
        trigger.send_keys(:arrow_down)
        links.first.send_keys(:escape)
        assert_no_selector "#service-nav"
        trigger.send_keys(:tab)
        page.find("main").hover
        assert_no_selector "#service-nav"
        assert_selector "#service-nav-link[aria-expanded='false']"
        trigger.hover
        assert_selector "#service-nav"
        page.find("main").hover
        assert_no_selector "#service-nav"
        @measurements << {locale: locale, width: width, reachable_service_links: links.size}
      end
    end
  end

  def test_offices_have_a_gutter_and_wrap_inside_each_column
    %i[cn en].each do |locale|
      [1340, 1024, 768, 390].each do |width|
        visit_sample(locale, width)
        page.find("#office-sample [data-biz-map-target='city']").click
        cards = page.all("#office-sample .office-addresses > div")
        assert_equal 2, cards.size
        left, right = cards.map(&:rect)
        if width >= 1024
          assert_in_delta left.y, right.y, 0.5
          gutter = right.x - (left.x + left.width)
          assert_in_delta 48, gutter, 0.5
          assert_in_delta left.width, right.width, 0.5
          if locale == :en
            title = cards.first.find("h1", match: :first)
            assert_operator title.rect.height, :>, title.evaluate_script("parseFloat(getComputedStyle(this).lineHeight)")
          end
        else
          assert_in_delta left.x, right.x, 0.5
          assert_operator right.y, :>=, left.y + left.height
          gutter = 0
        end
        cards.each do |card|
          assert_operator card.evaluate_script("this.scrollWidth - this.clientWidth"), :<=, 1
        end
        section = page.find("#office-sample")
        assert_operator section.evaluate_script("this.scrollWidth - this.clientWidth"), :<=, 1
        @measurements << {locale: locale, width: width, gutter: gutter, card_widths: cards.map { |card| card.rect.width }, overflow: section.evaluate_script("this.scrollWidth - this.clientWidth")}
        if [1340, 390].include?(width)
          page.scroll_to(page.find("#office-sample"), align: :center)
          page.find("#office-sample").native.save_screenshot(@output.join("offices-#{locale}-#{width}.png"))
        end
      end
    end
  end

  private

  def visit_sample(locale, width)
    page.driver.browser.execute_cdp("Emulation.setDeviceMetricsOverride", width: width, height: 1000, deviceScaleFactor: 1, mobile: false)
    page.visit("/#{locale}")
    page.evaluate_async_script("const done = arguments[0]; document.fonts.ready.then(() => done(true))")
    @measurements << page.evaluate_script("({viewportWidth: innerWidth, viewportHeight: innerHeight, contentWidth: document.documentElement.clientWidth, outerWidth, outerHeight})")
    assert_selector ".footer-social"
  end

  def token_line_count(element, token)
    element.evaluate_script(<<~JS, token)
      (() => {
        const node = this.firstChild;
        const start = node.textContent.indexOf(arguments[0]);
        const range = document.createRange();
        range.setStart(node, start);
        range.setEnd(node, start + arguments[0].length);
        return new Set(Array.from(range.getClientRects(), r => r.top)).size;
      })()
    JS
  end

  def contrast_on_white(color)
    channels = color.scan(/[\d.]+/).first(3).map do |value|
      channel = value.to_f / 255
      (channel <= 0.04045) ? channel / 12.92 : ((channel + 0.055) / 1.055)**2.4
    end
    1.05 / (channels.zip([0.2126, 0.7152, 0.0722]).sum { |channel, weight| channel * weight } + 0.05)
  end

  def render_sample(locale, overlays: false)
    controller = overlays ? HomeController.new : WorksController.new
    controller.request = ActionDispatch::Request.new(Rack::MockRequest.env_for("/works/residential"))
    controller.response = ActionDispatch::Response.new
    controller.action_name = overlays ? "show" : "residential"
    view = controller.view_context
    cities = Object.new
    %i[where select order].each { |method| cities.define_singleton_method(method) { |*| self } }
    cities.define_singleton_method(:group_by) { |&| {} }
    I18n.with_locale(locale) do
      City.stub(:with_published_works, cities) do
        nav = view.render(partial: "shared/thape_nav")
        footer = view.render(partial: "shared/footer")
        cards = TITLES.map.with_index do |title, index|
          info = OpenStruct.new(id: index + 1, title: title, created_at: Time.utc(2026, 1, 1), snapshot: OpenStruct.new(url: view.asset_pack_path("static/images/residential-1.jpg")))
          view.render(partial: "news/news_square", locals: {info: info, news_class: "relative overflow-hidden hover-scale"})
        end.join
        offices = render_offices(view)
        contacts = overlays ? render_contacts(view) : ""
        <<~HTML
          <!doctype html><html lang="#{locale}"><head><meta charset="utf-8">
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <meta http-equiv="Content-Security-Policy" content="default-src 'self' data:; style-src 'self' 'unsafe-inline'; script-src 'self'; connect-src 'none'; form-action 'none'">
          #{view.stylesheet_pack_tag("application")}
          #{view.javascript_pack_tag("application", defer: true)}
          <title>Public components — fixed samples</title></head><body class="font-sans">
          #{nav}<main style="min-height: 600px; padding: 32px 20px;">
          <p style="margin-bottom: 24px;">固定样本 · 真实导航、新闻卡片和页脚模板</p>
          <div class="flex-grid"><div class="flex-grid-box flex-grid-cols-2-gap-1 sm:flex-grid-cols-2-gap-2 md:flex-grid-cols-3-gap-2 lg:flex-grid-cols-4-gap-2">#{cards}</div></div>
          </main>#{contacts}#{footer}#{offices}</body></html>
        HTML
      end
    end
  end

  def render_offices(view)
    view.lookup_context.prefixes.unshift("biz_maps")
    shanghai = OpenStruct.new(
      long_name: I18n.t("map.contact-shanghai-name"),
      address: [I18n.t("map.contact-shanghai-address-1"), I18n.t("map.contact-shanghai-address-2")].join("|||"),
      tel: "021-00000000"
    )
    aico = OpenStruct.new(long_name: "AICO", address: "Fixed sample address", website_name: "long-domain-" * 12, website_url: "#company-website")
    city = view.render(partial: "biz_maps/city_mini", locals: {c: "上海", dc: "上海", e: "SHANGHAI"})
    panel = view.render(partial: "biz_maps/city_div", locals: {c: "上海", e: "SHANGHAI", ms: [shanghai, aico]})
    company = view.render(partial: "biz_maps/mobile_map_address", locals: {c: "sample", marks: [shanghai, aico] * 4})
    <<~HTML
      <section id="office-sample" data-controller="biz-map" class="px-4 sm:px-2 md:px-6 lg:px-8 xl:px-10 xxl:px-12 xxxl:px-16">
        <div class="px-0 py-4 sm:px-8 md:px-12 lg:px-16 xl:px-24 xxl:px-36">
          <p>固定样本 · 真实机构模板（含超长网址压力样本）</p>
          #{city}#{panel}
          <button type="button" data-biz-map-target="company" data-city="上海" data-company="sample" data-active-class="bg-gray-100" data-inactive-class="bg-gray-50" data-action="biz-map#selectCompany">固定样本 · 公司详情 / Company details</button>
          <div class="block xl:hidden">#{company}</div>
        </div>
      </section>
    HTML
  end

  def render_contacts(view)
    <<~HTML
      <section id="contact-sample" class="relative" data-controller="modal" data-action="keydown@window->modal#keydown">
        <p>固定样本 · 真实联系方式及合作弹窗 / Fixed samples</p>
        #{view.image_pack_tag("images/contact.jpg", class: "w-full")}
        #{view.render(partial: "biz_maps/contact_methods")}
        #{view.render(partial: "biz_maps/project_message_dialog")}
      </section>
    HTML
  end

  def guard_browser_requests
    browser = page.driver.browser
    address = browser.capabilities["goog:chromeOptions"]["debuggerAddress"]
    target = JSON.parse(Net::HTTP.get(URI("http://#{address}/json/list"))).find { |item| item["type"] == "page" }
    @socket = Selenium::WebDriver::WebSocketConnection.new(url: target.fetch("webSocketDebuggerUrl"))
    @requests = []
    @socket.add_callback("Fetch.requestPaused") do |event|
      request = event.fetch("request")
      uri = URI(request.fetch("url"))
      allowed = %w[GET HEAD].include?(request["method"]) && %w[127.0.0.1 localhost].include?(uri.host)
      @requests << {method: request["method"], host: uri.host, allowed: allowed}
      params = {requestId: event["requestId"]}
      params[:errorReason] = "BlockedByClient" unless allowed
      @socket.send_cmd(method: allowed ? "Fetch.continueRequest" : "Fetch.failRequest", params: params)
    end
    @socket.send_cmd(method: "Fetch.enable", params: {patterns: [{urlPattern: "*", requestStage: "Request"}]})
  end
end
