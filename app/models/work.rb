# frozen_string_literal: true

class Work < ApplicationRecord
  has_many :work_project_types, dependent: :destroy
  has_many :project_types, through: :work_project_types

  has_many :work_residential_types, dependent: :destroy
  has_many :residential_types, through: :work_residential_types

  belongs_to :city

  has_many :work_pictures

  mount_uploader :snapshot_jpg, JpgUploader
  mount_uploader :snapshot_webp, WebpUploader
  paginates_per 6

  translates :project_name, :client, :services, :team, :cooperation, :awards,
    :design_completion_lines, :construction_completion_lines, :architecture_area_lines

  def write_tianwen_xml(prefix = 'works')
    Tianwen.write_xml([prefix, id].join('_')) do |tmpl|
      tmpl.at_css('TRS_VERSION').content = 'E01'
      tmpl.at_css('TRS_CATEGORY').content = '作品'
      tmpl.at_css('TRS_PRIMARY').content = "web_work_#{id}"
      tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata(project_name))
      tmpl.at_css('TRS_CONTENT').add_child(tmpl.create_cdata(client))
      tmpl.at_css('TRS_CREATETIME').add_child(tmpl.create_cdata(created_at.to_s(:db)))
      tmpl.at_css('TRS_ORG').add_child(tmpl.create_cdata(team))
      tmpl.at_css('TRS_CATEGORY2').add_child(tmpl.create_cdata(project_types.collect(&:cn_name)&.join(',')))
      tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.work_url(id: id)))
      tmpl.at_css('TRS_CRESERVED1').add_child(tmpl.create_cdata(snapshot_jpg.url(thumb: '?x-oss-process=image/resize,w_327')))
      tmpl.at_css('TRS_CRESERVED2').add_child(tmpl.create_cdata(team))
      tmpl.at_css('TRS_CRESERVED3').add_child(tmpl.create_cdata("#{coordinate_lat},#{coordinate_lng}"))
      tmpl.at_css('TRS_CRESERVED4').add_child(tmpl.create_cdata(awards))
      tmpl.at_css('TRS_OPP').content = 1 # 1 for create, 2 for modify
    end
  end
end
