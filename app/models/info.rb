# frozen_string_literal: true

class Info < ApplicationRecord
  mount_uploader :picture, PictureUploader
  mount_uploader :banner, BannerUploader
  mount_uploader :snapshot, SnapshotUploader

  has_many :pictures

  validates :title, presence: true
  validates :introduction, presence: true
  validates :content, presence: true

  before_create :set_new_position
  paginates_per 12


  def write_tianwen_xml(tmpl)
    tmpl.at_css('TRS_PRIMARY').content = "web_info_#{id}"
    tmpl.at_css('TRS_TITLE').add_child(tmpl.create_cdata(title))
    tmpl.at_css('TRS_CONTENT').add_child(tmpl.create_cdata(ActionController::Base.helpers.strip_tags(content)))
    tmpl.at_css('TRS_CREATETIME').add_child(tmpl.create_cdata(created_at.to_s(:db)))
    tmpl.at_css('TRS_KEYWORDS').add_child(tmpl.create_cdata(seo_keywords))
    tmpl.at_css('TRS_SUMMARY').add_child(tmpl.create_cdata(seo_description))
    tmpl.at_css('TRS_BACKLINK').add_child(tmpl.create_cdata(Rails.application.routes.url_helpers.news_url(id: id)))
    tmpl.at_css('TRS_CRESERVED1').add_child(tmpl.create_cdata(snapshot.url(thumb: '?x-oss-process=image/resize,w_327')))
    tmpl.at_css('TRS_OPP').content = 1 # 1 for create, 2 for modify

    tgt_dir = Rails.root.join('public', 'tianwen_sync', "news_#{id}.xml")
    File.open(tgt_dir, 'wb') do |f|
      f.write(tmpl.to_xml)
    end
  end

  private

    def set_new_position
      self.position = Info.count
    end
end
