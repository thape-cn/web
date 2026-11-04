# frozen_string_literal: true

require "test_helper"
require "support/chrome_stale_element_retry"

class ChromeStaleElementRetryTest < ActiveSupport::TestCase
  setup do
    session = Capybara::Session.new(:selenium_chrome)
    @node = Capybara::Node::Base.new(session, nil)
    @stale_error = Selenium::WebDriver::Error::UnknownError.new(
      'unknown error: unhandled inspector error: {"code":-32000,"message":"Node with given id does not belong to the document"}'
    )
  end

  test "a Chrome detached node is reloaded before retrying the operation" do
    attempts = 0
    reloads = 0
    @node.stub(:reload, -> { reloads += 1 }) do
      result = @node.synchronize do
        attempts += 1
        raise @stale_error if attempts == 1
        :loaded
      end
      assert_equal :loaded, result
    end
    assert_equal 2, attempts
    assert_equal 1, reloads
  end

  test "unrelated Chrome errors fail immediately" do
    error = Selenium::WebDriver::Error::UnknownError.new("unknown error: browser disconnected")
    attempts = 0
    raised = assert_raises(Selenium::WebDriver::Error::UnknownError) do
      @node.synchronize do
        attempts += 1
        raise error
      end
    end
    assert_same error, raised
    assert_equal 1, attempts
  end

  test "a persistent detached node still fails when the Capybara timeout expires" do
    raised = assert_raises(Selenium::WebDriver::Error::UnknownError) do
      @node.synchronize(0) { raise @stale_error }
    end
    assert_same @stale_error, raised
  end

  test "ordinary stale elements still use the existing retry behavior" do
    attempts = 0
    @node.synchronize do
      attempts += 1
      raise Selenium::WebDriver::Error::StaleElementReferenceError if attempts == 1
    end
    assert_equal 2, attempts
  end
end
