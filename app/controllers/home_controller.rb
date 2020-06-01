class HomeController < ApplicationController
  layout 'home_page'
  def show
    @support_web = browser.chrome? || browser.firefox?
  end
end
