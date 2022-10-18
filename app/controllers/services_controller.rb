# frozen_string_literal: true

class ServicesController < ApplicationController
  before_action :set_service_file

  def building
    @seo = Seo.find_by(seo_name: '建筑设计服务')

    render 'services', locals: {
      background_img: t('services.building.background_img'),
      background_img_webp: t('services.building.background_img_webp'),
      chinese_title: t('services.building.chinese_title'),
      english_title: t('services.building.english_title'),
      ps: @service_file.building_intro.split("\n"),
      link_site_url: works_path,
      link_site_title: '天华项目'
    }
  end

  def interior
    @seo = Seo.find_by(seo_name: '室内设计服务')

    render 'services', locals: {
      background_img: t('services.interior.background_img'),
      background_img_webp: t('services.interior.background_img_webp'),
      chinese_title: t('services.interior.chinese_title'),
      english_title: t('services.interior.english_title'),
      ps: @service_file.interior_intro.split("\n"),
      link_site_url: interior_works_path,
      link_site_title: '天华室内项目'
    }
  end

  def planning
    @seo = Seo.find_by(seo_name: '城市规划服务')

    render 'services', locals: {
      background_img: t('services.planning.background_img'),
      background_img_webp: t('services.planning.background_img_webp'),
      chinese_title: t('services.planning.chinese_title'),
      english_title: t('services.planning.english_title'),
      ps: @service_file.planning_intro.split("\n"),
      link_site_url: urban_planning_works_path,
      link_site_title: '天华规划项目'
    }
  end

  def landscape
    @seo = Seo.find_by(seo_name: '景观设计服务')

    render 'services', locals: {
      background_img: t('services.landscape.background_img'),
      background_img_webp: t('services.landscape.background_img_webp'),
      chinese_title: t('services.landscape.chinese_title'),
      english_title: t('services.landscape.english_title'),
      ps: @service_file.landscape_intro.split("\n"),
      link_site_url: landscape_works_path,
      link_site_title: '天华景观项目'
    }
  end

  def vetting
    @seo = Seo.find_by(seo_name: '审图服务')

    render 'services', locals: {
      background_img: t('services.vetting.background_img'),
      background_img_webp: t('services.vetting.background_img_webp'),
      chinese_title: t('services.vetting.chinese_title'),
      english_title: t('services.vetting.english_title'),
      ps: @service_file.vetting_intro.split("\n")
    }
  end

  def consluting
    @seo = Seo.find_by(seo_name: '技术咨询服务')

    render 'services', locals: {
      background_img: t('services.consluting.background_img'),
      background_img_webp: t('services.consluting.background_img_webp'),
      chinese_title: t('services.consluting.chinese_title'),
      english_title: t('services.consluting.english_title'),
      ps: @service_file.consluting_intro.split("\n")
    }
  end

  def vrtech
    @seo = Seo.find_by(seo_name: '可视化服务')

    render 'services', locals: {
      background_img: t('services.vrtech.background_img'),
      background_img_webp: t('services.vrtech.background_img_webp'),
      chinese_title: t('services.vrtech.chinese_title'),
      english_title: t('services.vrtech.english_title'),
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
