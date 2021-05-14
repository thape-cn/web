# frozen_string_literal: true

namespace :tianwen_sync do
  desc 'Sync all news'
  task all: %i[sync_news sync_works]

  desc 'Sync news'
  task sync_news: :environment do
    d4_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'D4.xml')
    tmpl = File.open(d4_tmpl_path) { |f| Nokogiri::XML(f) }

    Info.all.find_each do |info|
      info.write_tianwen_xml(tmpl)
    end
  end

  desc 'Sync works'
  task sync_works: :environment do
    e1_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'E1.xml')
    tmpl = File.open(e1_tmpl_path) { |f| Nokogiri::XML(f) }

    Work.all.find_each do |work|
      work.write_tianwen_xml(tmpl)
    end
  end
end
