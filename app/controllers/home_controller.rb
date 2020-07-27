class HomeController < ApplicationController
  def show
    @support_webp = browser.chrome? || browser.firefox?
    @wallpapers = []

    if browser.device.mobile?
      @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/01_background_mobile.jpg')
      @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/02_background_mobile.jpg')
      @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/03_background_mobile.jpg')
      @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/04_background_mobile.jpg')
      @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/05_background_mobile.jpg')
      @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/06_background_mobile.jpg')
    else
      if @support_webp
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/01_background.webp')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/02_background.webp')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/03_background.webp')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/04_background.webp')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/05_background.webp')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/06_background.webp')
      else
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/01_background.jpg')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/02_background.jpg')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/03_background.jpg')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/04_background.jpg')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/05_background.jpg')
        @wallpapers << ActionController::Base.helpers.asset_pack_path('media/images/06_background.jpg')
      end
    end

    @tail_home = TailHome.first
  end
end
