class HomeController < ApplicationController
  layout 'home_page'
  def show
    @support_webp = browser.chrome? || browser.firefox?
    @wallpapers = []

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
end
