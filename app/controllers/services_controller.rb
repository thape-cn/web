class ServicesController < ApplicationController
  layout 'service_page'

  def building
    render 'services', locals: {
      background_img: 'media/images/building.jpg',
      chinese_title: '建筑设计',
      english_title: 'ARCHITECTURE',
      p1: '天华建筑，秉持“创意与技术完美融合”的品牌理念，致力于汇聚并培养专业人才团队，打造“体验与整合”为导向的创新设计。通过21个主要城市的分支机构网络，服务全国的客户和项目，专注营造品质生活空间、城市空间、文化空间、工作空间等，提供建筑、结构及机电工程咨询与设计全过程服务，涉足领域包括：住宅、商业、办公、城市综合体、城市更新、文化、医养、教育、旅居酒店等。',
      p2: '天华建筑立足于中国城市的快速发展，积极与国内外学术机构合作，设立五大研究中心，推动前沿课题的研究与实践，践行“引领生活方式，助力城市发展”的使命。'
    }
  end

  def interior
  end

  def planning
  end

  def landscape
  end

  def vetting
  end

  def consluting
  end

  def vrtech
  end
end
