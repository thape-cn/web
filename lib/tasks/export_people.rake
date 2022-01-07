# frozen_string_literal: true

namespace :import_people do
  desc 'Export people photo'
  task export_people_photo: :environment do
    Person.where(leaving_date: nil).each do |person|
      person.photo.cache_stored_file!
    end
    Person.where(leaving_date: nil).each do |person|
      puts person.photo.full_cache_path
    end
  end
end
