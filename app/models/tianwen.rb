class Tianwen
  def self.xml_to_dir(content, file_name)
    tgt_dir = Rails.configuration.tianwen_dir.join("#{file_name}.xml")
    File.open(tgt_dir, 'wb') do |f|
      f.write(content)
      if ENV['RAILS_ENV'] == 'production'
        f.chown(Rails.configuration.tianwen_uid, Rails.configuration.tianwen_gid)
      end
    end
  end
end