class Tianwen
  def self.xml_to_dir(content, file_name)
    tgt_dir = Rails.configuration.tianwen_dir.join("#{file_name}.xml")
    File.open(tgt_dir, 'wb') do |f|
      f.write(content)
    end
    if ENV['RAILS_ENV'] == 'production'
      File.chown(Rails.configuration.tianwen_user, Rails.configuration.tianwen_group, tgt_dir)
    end
  end
end