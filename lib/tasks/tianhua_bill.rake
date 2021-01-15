# frozen_string_literal: true

require 'csv'

namespace :tianhua_bill do
  desc 'Import the tianhua 2020'
  task :import_tianhua2020_data, [:csv_file_path] => [:environment] do |_task, args|
    csv_file_path = args[:csv_file_path]
    Tianhua2020.delete_all
    CSV.foreach(csv_file_path, headers: true) do |csv|
      Tianhua2020.create(csv.to_hash)
    end
  end
end
