# frozen_string_literal: true

namespace :tianwen_sync do
  desc 'Sync all news'
  task all: %i[sync_news sync_works]

  desc 'Sync news'
  task sync_news: :environment do
    d4_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'D4.xml')

    Info.all.find_each do |info|
      tmpl = File.open(d4_tmpl_path) { |f| Nokogiri::XML(f) }
      info.write_tianwen_xml(tmpl)
    end
  end

  desc 'Sync works'
  task sync_works: :environment do
    e1_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'E1.xml')
    Work.all.find_each do |work|
      tmpl = File.open(e1_tmpl_path) { |f| Nokogiri::XML(f) }
      work.write_tianwen_xml(tmpl)
    end
  end
end
