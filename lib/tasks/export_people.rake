# frozen_string_literal: true

namespace :export_people do
  desc 'Export people photo'
  task export_people_photo: :environment do
    Person.where(leaving_date: nil).each do |person|
      person.photo.cache_stored_file!
      bits = person.photo.read.unpack('B*')
      File.open("#{person.name}.jpg", 'wb') do |f|
        f.write(bits.pack('B*'))
      end
    end
  end
end
