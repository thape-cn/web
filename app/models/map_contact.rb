# frozen_string_literal: true

class MapContact < ApplicationRecord
  translates :name, :long_name, :alt_name, :address, :tel, :fax, :website_name

  def write_tianwen_xml(prefix = 'map_contacts')
    Tianwen.write_xml([prefix, id].join('_')) do |tmpl|
      tmpl.at_css('TRS_VERSION').content = 'G02'
      tmpl.at_css('TRS_ORG').content = '品牌与公关部'
      tmpl.at_css('TRS_CATEGORY').content = '联系方式'
      tmpl.at_css('TRS_PRIMARY').content = "web_map_contact_#{id}" # 主键, 必选
      tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata(long_name)) # 公司名称, 必选
      tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(address)) # 地址, 必选
      tmpl.at_css('TRS_ATTR2').add_child(tmpl.create_cdata(tel)) # 电话, 必选
      tmpl.at_css('TRS_ATTR3').add_child(tmpl.create_cdata(name)) # 城市, 必选
      tmpl.at_css('TRS_ATTR4').add_child(tmpl.create_cdata(fax)) # 传真, 必选
      tmpl.at_css('TRS_ATTR5').add_child(tmpl.create_cdata(website_url)) # 网址, 必选
      tmpl.at_css('TRS_OPP').content = 1 # 1 for create, 2 for modify
    end
  end
end
