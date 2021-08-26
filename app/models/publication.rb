# frozen_string_literal: true

class Publication < ApplicationRecord
  translates :title, :sub_title
  mount_uploader :pdf_file, PdfFileUploader
  mount_uploader :cover_jpg, JpgPngUploader
  mount_uploader :cover_webp, WebpUploader
  mount_uploader :mobile_cover_jpg, JpgPngUploader
  mount_uploader :mobile_cover_webp, WebpUploader
  mount_uploader :page_cover, PngUploader
  enum category_status: %i[monographs standard_specification paper_patent]

  def write_tianwen_xml(tmpl)
    tmpl.at_css('TRS_PRIMARY').content = "web_publication_#{id}" # 主键, 必选
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata(title)) # 文档标题, 必选
    tmpl.at_css('TRS_ATTACH_NAME').add_child(tmpl.create_cdata(pdf_file.identifier)) # 文件名称, 必选
    tmpl.at_css('TRS_ATTACH_PATH').add_child(tmpl.create_cdata(pdf_file.url)) # 完整路径, 必选
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(pdf_file.url)) # 完整路径, 必选
    tmpl.at_css('TRS_CREATETIME').add_child(tmpl.create_cdata(created_at.to_s(:db))) # 信息时间, 必选
    tmpl.at_css('TRS_CATEGORY').add_child(tmpl.create_cdata('出版物')) # 分类1, 必选
    tmpl.at_css('TRS_CATEGORY1').add_child(tmpl.create_cdata(I18n.t("publication.#{category_status}"))) # 分类1, 必选
    tmpl.at_css('TRS_CRESERVED1').add_child(tmpl.create_cdata(cover_jpg.url(thumb: '?x-oss-process=image/resize,w_327'))) # 缩略图标, 必选
    tmpl.at_css('TRS_CRESERVED2').add_child(tmpl.create_cdata(pdf_file.identifier.split('.').pop)) # 文件后缀, 必选
    tmpl.at_css('TRS_OPP').content = 1 # 1 for create, 2 for modify
  end
end
