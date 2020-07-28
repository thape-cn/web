class HomeController < ApplicationController
  def show
    @support_webp = browser.chrome? || browser.firefox?
    @tail_home = TailHome.first
    @wallpapers = []

    if browser.device.mobile?
      @wallpapers << @tail_home.background_1_mobile.url
      @wallpapers << @tail_home.background_2_mobile.url
      @wallpapers << @tail_home.background_3_mobile.url
      @wallpapers << @tail_home.background_4_mobile.url
      @wallpapers << @tail_home.background_5_mobile.url
      @wallpapers << @tail_home.background_6_mobile.url
    else
      if @support_webp
        @wallpapers << @tail_home.background_1_webp.url
        @wallpapers << @tail_home.background_2_webp.url
        @wallpapers << @tail_home.background_3_webp.url
        @wallpapers << @tail_home.background_4_webp.url
        @wallpapers << @tail_home.background_5_webp.url
        @wallpapers << @tail_home.background_6_webp.url
      else
        @wallpapers << @tail_home.background_1.url
        @wallpapers << @tail_home.background_2.url
        @wallpapers << @tail_home.background_3.url
        @wallpapers << @tail_home.background_4.url
        @wallpapers << @tail_home.background_5.url
        @wallpapers << @tail_home.background_6.url
      end
    end
  end
end
