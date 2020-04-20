class HomeController < ApplicationController
  layout 'home_page'
  def show
    if browser.ie?
      flash.now[:alert] = "本站点推荐在Chrome等非IE浏览器下浏览，Chrome浏览器可以在<a href='https://www.google.cn/chrome/'>https://www.google.cn/chrome/</a>下载。".html_safe
    end
  end
end
