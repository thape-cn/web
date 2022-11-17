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

    # 西北天华
    @m_西安天华 = MapContact.find(4)
    @m_郑州天华 = MapContact.find(15)
    @m_太原办事处 = MapContact.find(22)
    @m_新疆办事处 = MapContact.find(37)
    @m_兰州办事处 = MapContact.find(38)

    @m_上海天华 = MapContact.new({
      long_name: t("map.contact-shanghai-name"),
      alt_name: "",
      address: [t("map.contact-shanghai-address-1"), t("map.contact-shanghai-address-2")].join("|||"),
      tel: ["021-34189900", "021-64281588"].join("|||"),
      marketing_phone: "",
      media_phone: "",
      fax: "021-64281587",
      website_name: "",
      website_url: ""
    })

    # 地图上显示的城市点
    @map_cities = [
      {name: "上海", area: "上海", left: "81%", top: "61%"},
      {name: "北京", area: "北京", left: "67%", top: "35%"},
      {name: "深圳", area: "深圳", left: "67.5%", top: "84.5%"},
      {name: "广州", area: "广州", left: "63%", top: "80%"},
      {name: "天津", area: "天津", left: "72%", top: "39%"},
      {name: "重庆", area: "重庆", left: "54%", top: "66%"},
      {name: "武汉", area: "武汉", left: "68%", top: "64%"},
      {name: "成都", area: "成都", left: "48%", top: "63%"},
      {name: "西安", area: "西北地区", left: "53%", top: "54%"},
      {name: "沈阳", area: "沈阳", left: "78%", top: "28%"},
      {name: "厦门", area: "厦门", left: "73.5%", top: "81%"},
      {name: "福州", area: "福州", left: "75%", top: "74%"},
      {name: "青岛", area: "青岛", left: "78%", top: "46%"},
      {name: "南京", area: "南京", left: "74%", top: "55%"},
      {name: "郑州", area: "西北地区", left: "66%", top: "52%"},
      {name: "杭州", area: "杭州", left: "74%", top: "63%"},
      {name: "合肥", area: "合肥", left: "68%", top: "59%"},
      {name: "贵阳", area: "贵阳", left: "52%", top: "75%"},
      {name: "昆明", area: "昆明", left: "42%", top: "77%"},
      {name: "太原", area: "西北地区", left: "65%", top: "43%"},
      {name: "南昌", area: "南昌", left: "72%", top: "67%"},
      {name: "乌鲁木齐", area: "西北地区", left: "24%", top: "29%"},
      {name: "兰州", area: "西北地区", left: "41%", top: "46%"},
      {name: "长沙", area: "长沙", left: "64%", top: "70%"},
      {name: "香港", area: "香港", left: "65%", top: "88%"}
    ]

    # 地图上显示的城市联系信息
    @company_map_addresses = [
      {c: "上海天华", marks: [@m_上海天华]},
      {c: "北京天华", marks: [@m_北京天华]},
      {c: "深圳天华", marks: [@m_深圳天华]},
      {c: "广州天华", marks: [@m_广州天华]},
      {c: "天津天华", marks: [@m_天津天华]},
      {c: "重庆天华", marks: [@m_重庆天华]},
      {c: "武汉天华", marks: [@m_武汉天华]},
      {c: "成都天华", marks: [@m_成都天华]},
      {c: "西北地区集团", marks: [@m_西安天华, @m_郑州天华, @m_太原办事处, @m_新疆办事处, @m_兰州办事处]},
      {c: "沈阳天华", marks: [@m_沈阳天华]},
      {c: "厦门天华", marks: [@m_厦门天华]},
      {c: "青岛天华", marks: [@m_青岛天华]},
      {c: "南京天华", marks: [@m_南京天华]},
      {c: "杭州天华", marks: [@m_杭州天华]},
      {c: "合肥天华", marks: [@m_合肥天华]},
      {c: "贵阳天华", marks: [@m_贵阳天华]},
      {c: "昆明天华", marks: [@m_昆明天华]},
      {c: "长沙天华", marks: [@m_长沙天华]},
      {c: "福州天华", marks: [@m_福州天华]},
      {c: "南昌天华", marks: [@m_南昌办事处]},
      {c: "香港易爱迪", marks: [@m_香港天华]},
      {c: "上海易爱迪", marks: [@m_易爱迪]},
      {c: "上海爱坤", marks: [@m_爱坤]},
      {c: "上海室内", marks: [@m_上海室内]},
      {c: "上海城规", marks: [@m_上海城规]},
      {c: "上海园林", marks: [@m_上海园林]},
      {c: "虹核审图", marks: [@m_虹核审图]},
      {c: "易术家互娱", marks: [@m_易术家互娱]},
      {c: "上海嘉易", marks: [@m_上海嘉易]},
      {c: "上海医养", marks: [@m_上海医养]},
      {c: "深圳爱坤", marks: [@m_深圳AICO]},
      {c: "香港爱坤", marks: [@m_香港AICO]}
    ]

    # 地图旁边上半部分的公司列表
    @upper_map_companies = [
      {name: "上海天华", city: "上海", company: "上海天华"},
      {name: "北京天华", city: "北京", company: "北京天华"},
      {name: "深圳天华", city: "深圳", company: "深圳天华"},
      {name: "广州天华", city: "广州", company: "广州天华"},
      {name: "天津天华", city: "天津", company: "天津天华"},
      {name: "重庆天华", city: "重庆", company: "重庆天华"},
      {name: "武汉天华", city: "武汉", company: "武汉天华"},
      {name: "成都天华", city: "成都", company: "成都天华"},
      {name: "西北天华", city: "西北地区", company: "西北地区集团"},
      {name: "沈阳天华", city: "沈阳", company: "沈阳天华"},
      {name: "厦门天华", city: "厦门", company: "厦门天华"},
      {name: "青岛天华", city: "青岛", company: "青岛天华"},
      {name: "南京天华", city: "南京", company: "南京天华"},
      {name: "杭州天华", city: "杭州", company: "杭州天华"},
      {name: "合肥天华", city: "合肥", company: "合肥天华"},
      {name: "贵阳天华", city: "贵阳", company: "贵阳天华"},
      {name: "昆明天华", city: "昆明", company: "昆明天华"},
      {name: "长沙天华", city: "长沙", company: "长沙天华"},
      {name: "福州天华", city: "福州", company: "福州天华"},
      {name: "南昌办事处", city: "南昌", company: "南昌天华"}
    ]

    # 地图旁边下半部分的公司列表
    @under_map_companies = [
      {name: "易爱迪（香港）", city: "香港", company: "香港易爱迪"},
      {name: "易爱迪（上海）", city: "上海", company: "上海易爱迪"},
      {name: "AICO（上海）", city: "上海", company: "上海爱坤"},
      {name: "AICO（深圳）", city: "深圳", company: "深圳爱坤"},
      {name: "AICO（香港）", city: "香港", company: "香港爱坤"},
      {name: "上海天华规划", city: "上海", company: "上海城规"},
      {name: "上海天华室内", city: "上海", company: "上海室内"},
      {name: "上海天华景观", city: "上海", company: "上海园林"},
      {name: "易术家互娱科技", city: "上海", company: "易术家互娱"},
      {name: "上海虹核审图", city: "上海", company: "虹核审图"},
      {name: "上海天华嘉易", city: "上海", company: "上海嘉易"},
      {name: "上海天华医养", city: "上海", company: "上海医养"}
    ]

    # 机构的城市列表
    @cities = [
      {c: "上海", e: "SHANGHAI", ms: [@m_上海天华, @m_爱坤, @m_易爱迪, @m_上海城规, @m_上海室内, @m_上海园林, @m_易术家互娱, @m_虹核审图, @m_上海嘉易, @m_上海医养]},
      {c: "北京", e: "BEIJING", ms: [@m_北京天华]},
      {c: "深圳", e: "SHENZHEN", ms: [@m_深圳天华, @m_深圳AICO]},
      {c: "广州", e: "GUANGZHOU", ms: [@m_广州天华]},
      {c: "天津", e: "TIANJIN", ms: [@m_天津天华]},
      {c: "重庆", e: "CHONGQING", ms: [@m_重庆天华]},
      {c: "武汉", e: "WUHAN", ms: [@m_武汉天华]},
      {c: "成都", e: "CHENGDU", ms: [@m_成都天华]},
      {c: "西北", dc: "西北地区", e: "NORTHWEST", ms: [@m_西安天华, @m_郑州天华, @m_太原办事处, @m_新疆办事处, @m_兰州办事处]},
      {c: "沈阳", e: "SHENYANG", ms: [@m_沈阳天华]},
      {c: "厦门", e: "XIAMEN", ms: [@m_厦门天华]},
      {c: "青岛", e: "QINGDAO", ms: [@m_青岛天华]},
      {c: "南京", e: "NANJING", ms: [@m_南京天华]},
      {c: "杭州", e: "HANGZHOU", ms: [@m_杭州天华]},
      {c: "合肥", e: "HEFEI", ms: [@m_合肥天华]},
      {c: "贵阳", e: "GUIYANG", ms: [@m_贵阳天华]},
      {c: "昆明", e: "KUNMING", ms: [@m_昆明天华]},
      {c: "长沙", e: "CHANGSHA", ms: [@m_长沙天华]},
      {c: "福州", e: "FUZHOU", ms: [@m_福州天华]},
      {c: "南昌", e: "NANCHANG", ms: [@m_南昌办事处]},
      {c: "香港", e: "HONGKONG", ms: [@m_香港天华, @m_香港AICO]}
    ]
  end
end
