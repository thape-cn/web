class ServicesController < ApplicationController
  before_action :set_service_file

  def building
    render 'services', locals: {
      background_img: 'media/images/building.jpg',
      background_img_webp: '',
      chinese_title: '建筑设计',
      english_title: 'ARCHITECTURE',
      ps: @service_file.building_intro.split("\n"),
      link_site_url: works_path,
      link_site_title: '天华项目'
    }
  end

  def interior
    render 'services', locals: {
      background_img: 'media/images/interior.jpg',
      background_img_webp: 'media/images/interior.webp',
      chinese_title: '室内设计',
      english_title: 'INTERIOR',
      ps: @service_file.interior_intro.split("\n"),
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
      ps: @service_file.planning_intro.split("\n"),
      link_site_url: urban_planning_works_path,
      link_site_title: '天华规划项目'
    }
  end

  def landscape
    render 'services', locals: {
      background_img: 'media/images/landscape.jpg',
      background_img_webp: '',
      chinese_title: '景观设计',
      english_title: 'LANDSCAPE',
      ps: @service_file.landscape_intro.split("\n"),
      link_site_url: landscape_works_path,
      link_site_title: '天华景观项目'
    }
  end

  def vetting
    render 'services', locals: {
      background_img: 'media/images/vetting.jpg',
      background_img_webp: '',
      chinese_title: '审图',
      english_title: 'DRAWING REVIEW',
      ps: @service_file.vetting_intro.split("\n")
    }
  end

  def consluting
    render 'services', locals: {
      background_img: 'media/images/consluting.jpg',
      background_img_webp: '',
      chinese_title: '技术咨询',
      english_title: 'CONSULTATION',
      ps: @service_file.consluting_intro.split("\n")
    }
  end

  def vrtech
    render 'services', locals: {
      background_img: ['media/images/vrtech-1.jpg','media/images/vrtech-2.jpg','media/images/vrtech-3.jpg','media/images/vrtech-4.jpg','media/images/vrtech-5.jpg','media/images/vrtech-6.jpg'],
      background_img_webp: [],
      chinese_title: '可视化',
      english_title: 'VISUALIZATION',
      ps: @service_file.vrtech_intro.split("\n"),
      link_site_url: 'http://www.evartech.com/',
      link_site_title: '易术家'
    }
  end

  private

  def set_service_file
    @service_file = ServiceFile.first
  end
end
