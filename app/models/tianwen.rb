class Tianwen
  def self.xml_to_dir(content, file_name)
    tgt_dir = Rails.configuration.tianwen_dir.join("#{file_name}.xml")
    File.open(tgt_dir, 'wb') do |f|
      f.chmod(0666)
      f.write(content)
    end
  end
end