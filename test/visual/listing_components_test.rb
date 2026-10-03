# frozen_string_literal: true

require_relative "experience_components_test"
return unless defined?(PublicComponentsTest)

# Globalize otherwise probes the schema while autoloading these classes, even
# though every record access below is stubbed. Do not open a database connection.
ApplicationRecord.stub(:table_exists?, false) do
  [MapContact, Work]
end

class PublicComponentsTest
  def test_category_actions_use_their_own_paths
    actions = %i[interior landscape urban_planning hospitality urban_design medical_care education cultural commercial mixed_used_tod supertall office demonstration_zone residential]
    actions.each do |action|
      controller = listing_controller(WorksController, action, "/works/#{action}")
      controller.params = {q: "fixed sample"}
      controller.define_singleton_method(:render_project_type) {}
      Seo.stub(:find_by, fixed_seo) do
        ProjectType.stub(:find_by, ->(**attributes) { OpenStruct.new(attributes) }) do
          controller.public_send(action)
        end
      end
      expected = controller.public_send("#{action}_works_path")
      assert_equal expected, controller.instance_variable_get(:@self_path), action.to_s
      assert_equal expected, controller.view_context.project_type_path(controller.instance_variable_get(:@project_type)), action.to_s
    end
    %i[residential_residence residential_community residential_rental].each do |action|
      controller = listing_controller(WorksController, action, "/works/#{action}")
      controller.define_singleton_method(:render_residential) {}
      Seo.stub(:find_by, fixed_seo) do
        ProjectType.stub(:find_by, OpenStruct.new(cn_name: "居住")) do
          ResidentialType.stub(:find_by, OpenStruct.new) { controller.public_send(action) }
        end
      end
      assert_equal controller.public_send("#{action}_works_path"), controller.instance_variable_get(:@self_path)
    end
  end

  def test_listing_empty_states_preserve_category_and_normal_results
    %i[cn en].each do |locale|
      LISTING_PATHS.each do |type, path|
        [1340, 320].each do |width|
          visit_experience("/listings/#{locale}/#{type}/empty", width)
          assert_text I18n.t("works.empty.title", locale: locale)
          assert_equal "center", page.find(".work-empty-state p").evaluate_script("getComputedStyle(this).textAlign")
          assert_selector ".work-empty-state a[href='#{path}']", text: I18n.t("works.empty.clear_filters", locale: locale)
          assert_selector "form[action='#{path}'] a[href='#{path}']", text: I18n.t("ui.reset", locale: locale)
          assert_no_selector ".flex-grid a[href^='/works/']"
          assert_no_selector "nav.border-t"
          assert_operator page.evaluate_script("document.documentElement.scrollWidth - innerWidth"), :<=, 1
          if type != :search
            assert_selector "header h1 a[href='#{path}']"
            assert_selector "ol li:last-child a[href='#{path}']"
          end
          if type == :category
            assert_selector "form input[name='city'][value='hangzhou']", visible: :all
            page.save_screenshot(@output.join("medical-empty-fixed-#{locale}-#{width}.png")) # standard:disable Lint/Debugger
          end
          reset = page.find(".work-empty-state a")
          assert_nil URI(reset[:href]).query
          reset.click
          settle
          assert_equal path, URI(page.current_url).path
          assert_no_selector ".work-empty-state"
          assert_selector ".flex-grid a[href='/works/9001']"
          assert_selector "nav.border-t a[href*='page=2']"
          @measurements << {locale: locale, width: width, template: type, reset_path: path, empty_and_normal: "passed"}
        end
      end
    end
  end

  def test_biz_map_title_wraps_for_both_font_preferences
    %i[cn en].each do |locale|
      visit_experience("/biz-map/#{locale}", 1440)
      %w[sm big sm].each_with_index do |size, iteration|
        if iteration.positive?
          set_viewport(1440, height: 1000)
          settle
          page.find("a[href='?ts=#{size}']").click
          settle
        end
        widths = (iteration == 2) ? [1440] : [1440, 1340, 390, 320]
        widths.each do |width|
          set_viewport(width, height: (width < 640) ? 844 : 1000)
          settle
          title = page.find(".biz-map-heading")
          headings = title.all("h1")
          assert_equal [I18n.t("biz_maps.intro.title", locale: locale), "TIANHUA IN CHINA"], headings.map(&:text)
          expected_sizes = if width < 640
            [20, 20]
          elsif size == "big"
            [36, 30]
          else
            [24, 18]
          end
          assert_equal expected_sizes, headings.map { |h| h.evaluate_script("parseFloat(getComputedStyle(this).fontSize)") }
          assert_equal((locale == :cn) ? "zh-CN" : "en", page.find("html", visible: :all)[:lang])
          bounds = title.rect
          headings.each do |heading|
            assert_operator heading.rect.x, :>=, bounds.x - 1
            assert_operator heading.rect.x + heading.rect.width, :<=, bounds.x + bounds.width + 1
            assert_operator heading.evaluate_script("this.scrollWidth - this.clientWidth"), :<=, 1
            assert_equal "visible", heading.evaluate_script("getComputedStyle(this).overflowX")
          end
          assert_operator page.evaluate_script("document.documentElement.scrollWidth - innerWidth"), :<=, 1
          if size == "big" && width >= 1340
            assert_operator headings.last.rect.y, :>=, headings.first.rect.y + headings.first.rect.height - 1
          end
          @measurements << {locale: locale, size: size, width: width, column: bounds.to_h, headings: headings.map { |h| h.rect.to_h }, restored: iteration == 2}
          if iteration == 1 && [1340, 320].include?(width)
            page.scroll_to(title, align: :center)
            settle
            page.save_screenshot(@output.join("biz-map-fixed-#{locale}-big-#{width}.png")) # standard:disable Lint/Debugger
          end
        end
      end
    end
  end

  private

  LISTING_PATHS = {category: "/works/medical-care", residential: "/works/residential-residence", city: "/works/hangzhou", search: "/works"}.freeze

  def listing_pages
    pages = {}
    %i[cn en].each do |locale|
      %w[sm big].each do |size|
        html = render_biz_map(locale, size)
        pages["/biz-map/#{locale}?ts=#{size}"] = html
        pages["/biz-map/#{locale}"] = html if size == "sm"
      end
      LISTING_PATHS.each do |type, path|
        pages["/listings/#{locale}/#{type}/empty"] = render_listing(locale, type, empty: true)
        pages[path] ||= render_listing(locale, type, empty: false)
      end
    end
    pages
  end

  def fixed_seo
    OpenStruct.new(home_title: "Fixed samples — full templates", description: "Fixed sample", abstract: "Fixed sample", keywords: "Fixed sample")
  end

  def listing_controller(klass, action, path, size: "sm")
    controller = klass.new
    controller.request = ActionDispatch::Request.new(Rack::MockRequest.env_for(path, "HTTP_COOKIE" => "ts=#{size}"))
    controller.request.path_parameters = {controller: klass.controller_path, action: action.to_s}
    controller.response = ActionDispatch::Response.new
    controller.action_name = action.to_s
    controller.instance_variable_set(:@seo, fixed_seo)
    controller
  end

  def with_fixed_navigation
    cities = Object.new
    %i[where not select order].each { |method| cities.define_singleton_method(method) { |*| self } }
    cities.define_singleton_method(:group_by) { |&| {} }
    cities.define_singleton_method(:each) { |&| }
    City.stub(:with_published_works, cities) { yield }
  end

  def render_biz_map(locale, size)
    controller = listing_controller(BizMapsController, :show, "/biz-map", size: size)
    contact = OpenStruct.new(long_name: "固定样本 / Fixed sample", address: "Fixed sample address", tel: "021-00000000")
    I18n.with_locale(locale) do
      with_fixed_navigation do
        MapContact.stub(:find, contact) do
          MapContact.stub(:new, ->(attributes) { OpenStruct.new(attributes) }) do
            controller.show
            controller.view_context.render(template: "biz_maps/show", layout: "layouts/application")
          end
        end
      end
    end
  end

  def render_listing(locale, type, empty:)
    action = {category: :medical_care, residential: :residential_residence, city: :show, search: :index}.fetch(type)
    controller = listing_controller(WorksController, action, LISTING_PATHS.fetch(type))
    controller.params = {controller: "works", action: action.to_s, q: empty ? "fixed-empty-query" : "fixed sample", city: "hangzhou", page: "1", per_page: "1"}
    controller.params[:id] = "hangzhou" if type == :city
    sample = OpenStruct.new(id: 9001, project_name: "固定样本 / Fixed sample", snapshot_jpg: OpenStruct.new(url: controller.view_context.asset_pack_path("static/images/residential-1.jpg")))
    works = Kaminari.paginate_array(empty ? [] : [sample, sample]).page(1).per(1)
    scope = Object.new
    %i[order includes where page].each { |method| scope.define_singleton_method(method) { |*| self } }
    scope.define_singleton_method(:per) { |*| works }
    controller.define_singleton_method(:works_query_scope) { |*| scope }
    template = nil
    controller.define_singleton_method(:render) { |name| template = name }
    project = OpenStruct.new(id: 8, cn_name: "医疗康养", en_name: "MEDICAL CARE")
    projects = OpenStruct.new(all: [project])
    city = OpenStruct.new(id: 16, name: "杭州", url_name: "hangzhou", works: scope)
    I18n.with_locale(locale) do
      with_fixed_navigation do
        Seo.stub(:find_by, fixed_seo) do
          ProjectType.stub(:find_by, project) do
            ProjectType.stub(:order, projects) do
              ResidentialType.stub(:find_by, OpenStruct.new(id: 1, cn_name: "精品住宅", en_name: "RESIDENCE")) do
                City.stub(:find_by, city) do
                  controller.public_send(action)
                  controller.view_context.render(template: "works/#{template}", layout: "layouts/application")
                end
              end
            end
          end
        end
      end
    end
  end
end
