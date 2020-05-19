class BizMapsController < ApplicationController
  def show
    @m_易爱迪 = MapContact.find(23)
    @m_爱坤 = MapContact.find(24)
    @m_上海室内 = MapContact.find(25)
    @m_上海城规 = MapContact.find(27)
    @m_上海园林 = MapContact.find(28)
    @m_虹核审图 = MapContact.find(29)
    @m_易术家互娱 = MapContact.find(26)
    @m_易衡光伏 = MapContact.find(30)
    @m_易湃环境 = MapContact.find(31)
    @m_北京天华 = MapContact.find(3)
  end
end
