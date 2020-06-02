class HomeController < ApplicationController
  layout 'home_page'
  def show
    @support_webp = browser.chrome? || browser.firefox?
  end
end
