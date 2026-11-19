# frozen_string_literal: true

require "test_helper"
require "support/chrome_session_reset"

class ChromeSessionResetTest < ActiveSupport::TestCase
  test "reset discards the browser when Chrome rejects the wildcard storage origin" do
    driver = driver_with_reset_error("invalid argument: * is not a valid URL\n  (Session info: chrome=158.0.8127.37)")
    quit_calls = 0

    driver.stub(:quit, -> { quit_calls += 1 }) { driver.reset! }

    assert_equal 1, quit_calls
  end

  test "reset propagates unrelated Chrome errors" do
    driver = driver_with_reset_error("invalid argument: invalid window handle")

    error = assert_raises(Selenium::WebDriver::Error::InvalidArgumentError) { driver.reset! }

    assert_equal "invalid argument: invalid window handle", error.message
  end

  private

  def driver_with_reset_error(message)
    driver = Object.new
    driver.define_singleton_method(:reset!) { raise Selenium::WebDriver::Error::InvalidArgumentError, message }
    driver.define_singleton_method(:quit) { flunk "The browser should only quit for the wildcard origin error" }
    driver.singleton_class.prepend(ChromeSessionReset)
    driver
  end
end
