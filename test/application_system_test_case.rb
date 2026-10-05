# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # removes noisy logs when launching tests
  Capybara.server = :puma, {Silent: true}

  Capybara.register_driver :headless_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new(args: %w[headless window-size=1400,1000])
    options.add_option("goog:loggingPrefs", {browser: "ALL"})
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.register_driver(:chrome) do |app|
    options = Selenium::WebDriver::Chrome::Options.new(args: %w[window-size=1400,1000])
    options.add_option("goog:loggingPrefs", {browser: "ALL"})
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  ENV["HEADLESS"] ? driven_by(:headless_chrome) : driven_by(:chrome)

  teardown do
    unless passed?
      page.driver.browser.logs.get(:browser).each do |entry|
        warn "[Browser #{entry.level}] #{entry.message}"
      end
    end

    if @viewport_emulated
      page.driver.browser.execute_cdp("Emulation.clearDeviceMetricsOverride")
    end
  end

  # Chrome limits window width on desktop; emulate the viewport for phone sizes.
  def resize_viewport(width, height)
    page.driver.browser.execute_cdp("Emulation.setDeviceMetricsOverride",
      width: width, height: height, deviceScaleFactor: 1, mobile: false)
    @viewport_emulated = true
  end
end
