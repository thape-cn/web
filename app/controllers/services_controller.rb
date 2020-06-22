class ServicesController < ApplicationController
  def building
    render 'services', locals: {
      background_img: 'media/images/building.jpg',
      background_img_webp: '',
      chinese_title: '建筑设计',
      english_title: 'ARCHITECTURE',
      ps: ['天华建筑秉持“创意与技术完美融合”的品牌理念，致力于汇聚并培养专业人才团队，追求“体验与整合”为导向的创新设计。通过21个主要城市的分支机构网络，服务全国的客户和项目，专注营造高品质生活空间、城市空间、文化空间、工作空间等优秀的建筑产品，提供建筑、结构及机电等全专业工程咨询与设计全过程服务，涉足领域包括：住宅、商业、办公、城市综合体、城市更新、城市设计、TOD、文化、医养、教育、旅居酒店等。',
           '天华建筑长期立足于中国城市的快速发展方向，积极与国内外学术机构合作，设立八大研究中心，推动前沿课题的研究与实践，与客户、行业上下游合作伙伴携手同行，为解决中国城市建设与发展问题不懈努力，践行“引领生活方式，助力城市发展”的使命。'],
    }
  end

  def interior
    render 'services', locals: {
      background_img: 'media/images/interior.jpg',
      background_img_webp: 'media/images/interior.webp',
      chinese_title: '室内设计',
      english_title: 'INTERIOR',
      ps: ['“天华·易筑”是天华集团创意业务板块室内设计与工程业务的重要组成部分，凭借其独特的创意设计能力、技术落地能力、项目管理能力、成本控制能力以及服务响应能力赢得了业界的一致认可和信任。为了满足不断增加的业务需求，“天华·易筑”在2013年初独立成为上海天华室内设计有限公司，并于2018年成立深圳和武汉区域子公司负责拓展华南和华中市场。 “天华·易筑”致力于办公空间、居住空间、商业零售空间、会所和售楼处等的高端室内空间的营造。',
           '“天华”秉承着天华集团一贯的富有特色的创新能力；“易筑”代表着强大的技术和完美的工程落地能力；“天华·易筑”科学地统筹“咨询、设计、技术、管理”互联的高效服务模式，因地制宜地为不同室内空间提供具有创新性和经济性的解决方案。'],

      link_site_url: 'http://www.thyizhu.com/',
      link_site_title: '天华易筑'
    }
  end

  def planning
    render 'services', locals: {
      background_img: 'media/images/planning.jpg',
      background_img_webp: '',
      chinese_title: '城市规划',
      english_title: 'URBAN PLANNING',
      ps: ['天华规划，秉持以责任规划城市的可持续发展理念，以国际化大都市先进发展经验为基础，鼓励跨行业多视角的合作，追求资源整合效率的最大化，并致力于成为全球最佳城市发展咨询合作伙伴。',
           '天华规划年轻而有活力的团队毕业于世界各地的一流院校，拥有多名博士，硕士学历超过三分之二，视野兼具专业深度与全球广度。',
           '天华规划在以下六大领域各有建树: 区域规划 | 城市设计 | 社区发展 | 文旅小镇 | 产业策划 | 城乡更新',
           '能够承担从区域战略规划、总体规划到详细规划、城市设计以及交通、景观、低碳、村镇及遗产保护等多元领域的综合规划，并践行独具特色的一站式综合咨询服务模式，为客户达成整体解决方案，持续不懈打造宜居中国城市规划品牌。']
    }
  end

  def landscape
    render 'services', locals: {
      background_img: 'media/images/landscape.jpg',
      background_img_webp: '',
      chinese_title: '景观设计',
      english_title: 'LANDSCAPE',
      ps: ['天华景观凭借优秀的设计水准及专业完善的服务赢得业界好评，积累了众多知名客户长期合作伙伴，项目涵盖居住区景观、公建景观、绿地公园等各领域。全新打造的天华景观团队，具有国际化的队伍组合，完善的技术力量，全程化的总体服务，严谨的工作流程。',
           '设计聚焦于项目的本质，最大化场地潜力，基于科学的分析，创新的想法以及合理的工作流程，提供最合理、最经济、最可持续发展的设计方案。']
    }
  end

  def vetting
    render 'services', locals: {
      background_img: 'media/images/vetting.jpg',
      background_img_webp: '',
      chinese_title: '审图',
      english_title: 'DRAWING REVIEW',
      ps: ['虹核审图业务团队主营建设工程审图，2001年获得上海市建交委员会颁发的上海市建设工程施工图设计文件审查（一类含超限高层）机构认定资质，是上海市最早的11家审图机构之一。',
           '虹核审图于2006年12月获得ISO9001质量体系认证证书，建有一套质量保证体系和管理标准。审查总量在全市审查机构中名列前茅，并多年被主管部门评为先进单位。']
    }
  end

  def consluting
    render 'services', locals: {
      background_img: 'media/images/consluting.jpg',
      background_img_webp: '',
      chinese_title: '技术咨询',
      english_title: 'CONSULTATION',
      ps: ['基于天华在建筑设计领域数十年的耕耘，天华提供项目全生命周期、全专业的技术顾问咨询服务，厚积薄发，源于设计，高于设计。服务范围涵盖建筑选型优化、项目成本预控、超高超限分析、新技术研发和应用（前沿居住研发、医养建筑研发、文旅建筑研发、城市更新与改造技术、TOD与城市设计、装配式建筑研发、BIM正向设计、建筑可视化技术研发、钢结构技术研发等）、规范标准编制、第三方审核、抗震审批等。',
           '天华致力于通过先进的技术、优秀的技术专家及人才团队、高效的组织和优质的服务，坚持创意与技术完美融合，最大限度地实现客户的价值目标，为行业发展与创建节能环保型社会做出贡献。']
    }
  end

  def vrtech
    render 'services', locals: {
      background_img: 'media/images/vrtech.jpg',
      background_img_webp: '',
      chinese_title: '可视化',
      english_title: 'VISUALIZATION',
      ps: ['可视化技术是是当下最热门的前沿技术之一，可视化技术在建筑领域的应用将给地产行业带来全新的思维模式和工作流程。易术家是建筑可视化技术领域的先行者，致力于为建筑工程行业提供可视化技术解决方案，利用1:1虚拟建造的方式赋能设计理念表达、设计验证、设计决策和工程管理。',
           '易术家定位于包括VR、AR等可视化技术在房地产市场和设计表现领域的垂直细分市场，致力于结合新兴的科技手段和集团在业内领先的建筑美学表达经验，提供高品质的可视化产品和服务，着力解决行业需求和改革现有的表达方式。',
           '依托于天华集团对地产行业全方位的了解，易术家能够最为准确地把握行业需求，并在各环节中提出创新的工作模式和高效的解决方案，帮助提升整个行业的工作效率。'],
      link_site_url: 'http://www.evartech.com/',
      link_site_title: '易术家'
    }
  end
end
