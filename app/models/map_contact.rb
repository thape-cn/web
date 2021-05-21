# frozen_string_literal: true

class MapContact < ApplicationRecord
  translates :name, :long_name, :alt_name, :address, :tel, :fax, :website_name

  def write_tianwen_xml(tmpl)
    tmpl.at_css('TRS_PRIMARY').content = "web_map_contact_#{id}" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata(long_name)) # 公司名称, 必选
    tmpl.at_css('TRS_CATEGORY').add_child(tmpl.create_cdata('联系方式')) # 分类, 必选
    tmpl.at_css('TRS_ATTR1').add_child(tmpl.create_cdata(address)) # 地址, 必选
    tmpl.at_css('TRS_ATTR2').add_child(tmpl.create_cdata(tel)) # 电话, 必选
    tmpl.at_css('TRS_ATTR3').add_child(tmpl.create_cdata(name)) # 城市, 必选
    tmpl.at_css('TRS_ATTR4').add_child(tmpl.create_cdata(fax)) # 传真, 必选
    tmpl.at_css('TRS_ATTR5').add_child(tmpl.create_cdata(website_url)) # 网址, 必选
    tmpl.at_css('TRS_OPP').content = 1 # 1 for create, 2 for modify

    tgt_dir = Rails.root.join('public', 'tianwen_sync', "map_contacts_#{id}.xml")
    File.open(tgt_dir, 'wb') do |f|
      f.write(tmpl.to_xml)
    end
  end
end
