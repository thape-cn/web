# frozen_string_literal: true

require "capybara"
require "selenium-webdriver"

module ChromeSessionReset
  def reset!
    super
  rescue Selenium::WebDriver::Error::InvalidArgumentError => error
    # Capybara 3.40 clears storage for origin "*", which Chrome 158 rejects.
    raise unless error.message.start_with?("invalid argument: * is not a valid URL")

    # Discard the temporary profile so cookies and storage cannot leak between tests.
    quit
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend(ChromeSessionReset)
