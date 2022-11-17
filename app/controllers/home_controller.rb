# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @support_webp = browser.chrome? || browser.firefox?
    @tail_home = TailHome.includes(work_1: :project_types, work_2: :project_types, work_3: :project_types, work_4: :project_types, work_5: :project_types, work_6: :project_types).first
    @wallpapers = []

    if browser.device.mobile?
      @wallpapers << @tail_home.background_1_mobile.url
      @wallpapers << @tail_home.background_2_mobile.url
      @wallpapers << @tail_home.background_3_mobile.url
      @wallpapers << @tail_home.background_4_mobile.url
      @wallpapers << @tail_home.background_5_mobile.url
      @wallpapers << @tail_home.background_6_mobile.url
    elsif @support_webp
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
