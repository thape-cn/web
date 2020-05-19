class BizMapsController < ApplicationController
  def show
    @m_易爱迪 = MapContact.find(23)
  end
end
