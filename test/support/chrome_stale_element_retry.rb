# frozen_string_literal: true

require "capybara"
require "selenium-webdriver"

module ChromeStaleElementRetry
  protected

  def catch_error?(error, errors = nil)
    # Chrome can misreport a detached node as UnknownError during navigation.
    # Let Capybara reload it within its normal timeout, as for a stale element.
    # https://github.com/teamcapybara/capybara/issues/2800
    super || (error.is_a?(Selenium::WebDriver::Error::UnknownError) &&
      error.message.include?("Node with given id does not belong to the document"))
  end
end

Capybara::Node::Base.prepend(ChromeStaleElementRetry)
