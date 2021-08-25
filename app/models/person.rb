# frozen_string_literal: true

class Person < ApplicationRecord
  has_many :city_people, dependent: :destroy
  has_many :cities, through: :city_people

  translates :name, :title, :introduce
  validates_uniqueness_of :url_name

  mount_uploader :avatar, AvatarUploader
  mount_uploader :photo, PhotoUploader

  before_create :set_new_position

  def write_tianwen_xml(tmpl)
    tmpl.at_css('TRS_VERSION').content = "C02" # 前端模板, 必选
    tmpl.at_css('TRS_PRIMARY').content = "web_person_#{id}" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata(name)) # 姓名, 必选
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(url_name)) # 英文名称, 必选
    tmpl.at_css('TRS_CONTENT').add_child(tmpl.create_cdata(ActionController::Base.helpers.strip_tags(introduce))) # 介绍, 必选
    tmpl.at_css('TRS_CREATETIME').add_child(tmpl.create_cdata(created_at.to_s(:db))) # 信息时间, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.leadership_url(id: url_name))) # URL地址, 必选
    tmpl.at_css('TRS_CRESERVED1').add_child(tmpl.create_cdata(avatar.url(thumb: '?x-oss-process=image/resize,w_327'))) # 缩略图, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(cities.pluck(:name).map { |city_name| category == 1 ? "#{city_name}管理团队" : "#{city_name}专业团队" }.join(','))) # 类别, 必选
    tmpl.at_css('TRS_ATTR2').add_child(tmpl.create_cdata(avatar.url)) # 头像, 必选
    tmpl.at_css('TRS_ATTR3').add_child(tmpl.create_cdata(title.gsub(/\s/, ' '))) # 岗位名称, 必选
    tmpl.at_css('TRS_ATTR5').add_child(tmpl.create_cdata(city_people.collect(&:city).collect(&:company_name)&.join(','))) # 公司, 必选
    tmpl.at_css('TRS_OPP').content = 1 # 1 for create, 2 for modify
  end

  private

    def set_new_position
      self.position = Person.count
    end
end
