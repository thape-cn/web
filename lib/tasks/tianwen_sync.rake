# frozen_string_literal: true

namespace :tianwen_sync do
  desc 'Sync all news'
  task all: %i[sync_news sync_works sync_persons sync_portfolios sync_publications]

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

  desc 'Sync persons'
  task sync_persons: :environment do
    c1_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'C1.xml')
    Person.all.find_each do |person|
      tmpl = File.open(c1_tmpl_path) { |f| Nokogiri::XML(f) }
      person.write_tianwen_xml(tmpl)
    end
  end

  desc 'Sync portfolios'
  task sync_portfolios: :environment do
    f3_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'F3.xml')
    Portfolio.all.find_each do |portfolio|
      tmpl = File.open(f3_tmpl_path) { |f| Nokogiri::XML(f) }
      portfolio.write_tianwen_xml(tmpl)
    end
  end

  desc 'Sync publications'
  task sync_publications: :environment do
    f3_tmpl_path = Rails.root.join('public', 'tianwen_tile', 'F3.xml')
    Publication.all.find_each do |publication|
      tmpl = File.open(f3_tmpl_path) { |f| Nokogiri::XML(f) }
      publication.write_tianwen_xml(tmpl)
    end
  end
end
