# frozen_string_literal: true

namespace :tianwen_sync do
  desc 'Sync all news'
  task all: %i[sync_news]

  desc 'Sync news'
  task sync_news: :environment do
    Info.last.write_tianwen_xml
  end
end
