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

  def write_tianwen_xml(tmpl)
    tmpl.at_css('TRS_PRIMARY').content = id
    tmpl.at_css('TRS_TITLE').content = project_name
    tmpl.at_css('TRS_CONTENT').content = client
    tmpl.at_css('TRS_CREATETIME').content = created_at.to_s(:db)
    tmpl.at_css('TRS_ORG').content = team
    tmpl.at_css('TRS_CATEGORY2').content = project_types.collect(&:cn_name)&.join(',')
    tmpl.at_css('TRS_BACKLINK').content = Rails.application.routes.url_helpers.work_url(id: id)
    tmpl.at_css('TRS_ATTR1').content = snapshot_jpg.url(thumb: '?x-oss-process=image/resize,w_327')
    tmpl.at_css('TRS_CRESERVED3').content = "#{coordinate_lat},#{coordinate_lng}"
    tmpl.at_css('TRS_CRESERVED4').content = awards
    tmpl.at_css('TRS_OPP').content = 1 # 1 for create, 2 for modify

    tgt_dir = Rails.root.join('public', 'tianwen_sync', "works_#{id}.xml")
    File.open(tgt_dir, 'wb') do |f|
      f.write(tmpl.to_xml)
    end
  end
end
