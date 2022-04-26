# frozen_string_literal: true

class BizMapsController < ApplicationController
  def show
    @m_易爱迪 = MapContact.find(23)
    @m_爱坤 = MapContact.find(24)
    @m_上海室内 = MapContact.find(25)
    @m_上海城规 = MapContact.find(27)
    @m_上海园林 = MapContact.find(28)
    @m_虹核审图 = MapContact.find(29)
    @m_易术家互娱 = MapContact.find(26)
    @m_北京天华 = MapContact.find(3)
    @m_深圳天华 = MapContact.find(9)
    @m_广州天华 = MapContact.find(17)
    @m_天津天华 = MapContact.find(11)
    @m_重庆天华 = MapContact.find(6)
    @m_武汉天华 = MapContact.find(32)
    @m_成都天华 = MapContact.find(5)
    @m_沈阳天华 = MapContact.find(2)
    @m_厦门天华 = MapContact.find(8)
    @m_青岛天华 = MapContact.find(12)
    @m_南京天华 = MapContact.find(13)
    @m_杭州天华 = MapContact.find(16)
    @m_合肥天华 = MapContact.find(18)
    @m_贵阳天华 = MapContact.find(19)
    @m_昆明天华 = MapContact.find(20)
    @m_长沙天华 = MapContact.find(21)
    @m_香港天华 = MapContact.find(14)
    @m_香港天华 = MapContact.find(14)
    @m_武汉易筑 = MapContact.find(34) # no use any more
    @m_福州天华 = MapContact.find(35)
    @m_南昌办事处 = MapContact.find(36)
    @m_上海嘉易 = MapContact.find(39)
    @m_上海医养 = MapContact.find(40)
    @m_深圳AICO = MapContact.find(41)
    @m_香港AICO = MapContact.find(42)
    @m_深圳城规 = MapContact.find(43)

    # 西北天华
    @m_西安天华 = MapContact.find(4)
    @m_郑州天华 = MapContact.find(15)
    @m_太原办事处 = MapContact.find(22)
    @m_新疆办事处 = MapContact.find(37)
    @m_兰州办事处 = MapContact.find(38)
  end
end
