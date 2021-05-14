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


  def write_tianwen_xml
    d4_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'D4.xml')
    tmpl = File.open(d4_tmpl_path) { |f| Nokogiri::XML(f) }
    tmpl.at_css('TRS_PRIMARY').content = id
    tmpl.at_css('TRS_TITLE').content = title
    tmpl.at_css('TRS_CONTENT').content = ActionController::Base.helpers.strip_tags(content)
    tmpl.at_css('TRS_CREATETIME').content = created_at.to_s(:db)
    tmpl.at_css('TRS_KEYWORDS').content = seo_keywords
    tmpl.at_css('TRS_SUMMARY').content = seo_description
    tmpl.at_css('TRS_BACKLINK').content = Rails.application.routes.url_helpers.news_url(id: id)
    tmpl.at_css('TRS_ATTR1').content = snapshot.url
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
