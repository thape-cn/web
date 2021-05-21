# frozen_string_literal: true

class Portfolio < ApplicationRecord
  translates :title, :sub_title
  mount_uploader :pdf_file, PdfFileUploader
  mount_uploader :cover_jpg, JpgPngUploader
  mount_uploader :cover_webp, WebpUploader
  mount_uploader :mobile_cover_jpg, JpgPngUploader
  mount_uploader :mobile_cover_webp, WebpUploader
  mount_uploader :page_cover, PngUploader

  def write_tianwen_xml(tmpl)
    tmpl.at_css('TRS_PRIMARY').content = "web_publication_#{id}" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata(title)) # 文档标题, 必选
    tmpl.at_css('TRS_ATTACH_NAME').add_child(tmpl.create_cdata(pdf_file.identifier)) # 文件名称, 必选
    tmpl.at_css('TRS_ATTACH_PATH').add_child(tmpl.create_cdata(pdf_file.url)) # 完整路径, 必选
    tmpl.at_css('TRS_CREATETIME').add_child(tmpl.create_cdata(created_at.to_s(:db))) # 信息时间, 必选
    tmpl.at_css('TRS_CATEGORY').add_child(tmpl.create_cdata('官网作品集')) # 分类1, 必选
    tmpl.at_css('TRS_CRESERVED1').add_child(tmpl.create_cdata(cover_jpg.url(thumb: '?x-oss-process=image/resize,w_327'))) # 缩略图标, 必选
    tmpl.at_css('TRS_CRESERVED2').add_child(tmpl.create_cdata(cover_jpg.identifier.split('.').pop)) # 缩略图后缀, 必选
    tmpl.at_css('TRS_OPP').content = 1 # 1 for create, 2 for modify

    tgt_dir = Rails.root.join('public', 'tianwen_sync', "portfolios_#{id}.xml")
    File.open(tgt_dir, 'wb') do |f|
      f.write(tmpl.to_xml)
    end
  end
end
