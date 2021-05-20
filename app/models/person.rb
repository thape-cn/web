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
    tmpl.at_css('TRS_PRIMARY').content = "web_person_#{id}" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata(name)) # 姓名, 必选
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(url_name)) # 英文名称, 必选
    tmpl.at_css('TRS_CONTENT').add_child(tmpl.create_cdata(introduce)) # 介绍, 必选
    # tmpl.at_css('TRS_ATTACH_PATH').add_child(tmpl.create_cdata()) # 附件路径, 必选
    tmpl.at_css('TRS_CREATETIME').add_child(tmpl.create_cdata(created_at.to_s(:db))) # 信息时间, 必选
    # tmpl.at_css('TRS_ORG').add_child(tmpl.create_cdata()) # 部门, 必选
    # tmpl.at_css('TRS_CATEGORY1').add_child(tmpl.create_cdata()) # 分类1, 必选
    # tmpl.at_css('TRS_CATEGORY2').add_child(tmpl.create_cdata()) # 分类2, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.leadership_url(id: url_name))) # URL地址, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(avatar.url(thumb: '?x-oss-process=image/resize,w_327'))) # 缩略图, 必选
    tmpl.at_css('TRS_ATTR2').add_child(tmpl.create_cdata(avatar.url)) # 头像, 必选
    tmpl.at_css('TRS_ATTR3').add_child(tmpl.create_cdata(title)) # 岗位名称, 必选
    # tmpl.at_css('TRS_ATTR4').add_child(tmpl.create_cdata()) # 工位, 必选
    tmpl.at_css('TRS_ATTR5').add_child(tmpl.create_cdata(city_people.collect(&:city).collect(&:company_name)&.join(','))) # 公司, 必选
    # tmpl.at_css('TRS_ATTR6').add_child(tmpl.create_cdata()) # 性别, 必选
    # tmpl.at_css('TRS_ATTR7').add_child(tmpl.create_cdata()) # 邮箱, 必选
    # tmpl.at_css('TRS_ATTR8').add_child(tmpl.create_cdata()) # 工号, TH开头
    # tmpl.at_css('TRS_ATTR9').add_child(tmpl.create_cdata()) # 员工号
    # tmpl.at_css('TRS_ATTR10').add_child(tmpl.create_cdata()) # 手机
    tmpl.at_css('TRS_OPP').content = 1 # 1 for create, 2 for modify

    tgt_dir = Rails.root.join('public', 'tianwen_sync', "persons_#{id}.xml")
    File.open(tgt_dir, 'wb') do |f|
      f.write(tmpl.to_xml)
    end
  end

  private

    def set_new_position
      self.position = Person.count
    end
end
