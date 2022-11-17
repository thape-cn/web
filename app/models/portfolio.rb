# frozen_string_literal: true

class Portfolio < ApplicationRecord
  translates :title, :sub_title
  mount_uploader :pdf_file, PdfFileUploader
  mount_uploader :cover_jpg, JpgPngUploader
  mount_uploader :cover_webp, WebpUploader
  mount_uploader :mobile_cover_jpg, JpgPngUploader
  mount_uploader :mobile_cover_webp, WebpUploader
  mount_uploader :page_cover, PngUploader

  def write_tianwen_xml(prefix = "portfolios")
    Tianwen.write_xml([prefix, id].join("_")) do |tmpl|
      tmpl.at_css("TRS_VERSION").content = "F03"
      tmpl.at_css("TRS_ORG").content = "品牌与公关部"
      tmpl.at_css("TRS_CATEGORY").content = "作品集"
      tmpl.at_css("TRS_PRIMARY").content = "web_portfolio_#{id}" # 主键, 必选
      tmpl.at_css("TRS_TITLE").add_child(tmpl.create_cdata(title)) # 文档标题, 必选
      tmpl.at_css("TRS_ATTACH_NAME").add_child(tmpl.create_cdata(pdf_file.identifier)) # 文件名称, 必选
      tmpl.at_css("TRS_ATTACH_PATH").add_child(tmpl.create_cdata(pdf_file.url)) # 完整路径, 必选
      tmpl.at_css("TRS_BACKLINK").add_child(tmpl.create_cdata(pdf_file.url)) # 完整路径, 必选
      tmpl.at_css("TRS_CREATETIME").add_child(tmpl.create_cdata(created_at.to_s(:db))) # 信息时间, 必选
      tmpl.at_css("TRS_CRESERVED1").add_child(tmpl.create_cdata(cover_jpg.url(thumb: "?x-oss-process=image/resize,w_327"))) # 缩略图标, 必选
      tmpl.at_css("TRS_CRESERVED2").add_child(tmpl.create_cdata(pdf_file.identifier.split(".").pop)) # 文件后缀, 必选
      tmpl.at_css("TRS_OPP").content = 1 # 1 for create, 2 for modify
    end
  end
end
