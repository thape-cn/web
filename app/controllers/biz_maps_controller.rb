class BizMapsController < ApplicationController
  def show
    @m_易爱迪 = MapContact.find(23)
    @m_爱坤 = MapContact.find(24)
    @m_上海室内 = MapContact.find(25)
  end
end
