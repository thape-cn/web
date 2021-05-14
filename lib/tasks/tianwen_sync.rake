# frozen_string_literal: true

namespace :tianwen_sync do
  desc 'Sync all news'
  task all: %i[sync_news]

  desc 'Sync news'
  task sync_news: :environment do
    d4_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'D4.xml')
    tmpl = File.open(d4_tmpl_path) { |f| Nokogiri::XML(f) }

    Info.all.find_each do |info|
      info.write_tianwen_xml(tmpl)
    end
  end
end
