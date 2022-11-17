# frozen_string_literal: true

class Tianwen
  def self.xml_to_dir(content, file_name)
    tgt_dir = Rails.configuration.tianwen_dir.join("#{file_name}.xml")
    File.open(tgt_dir, "wb") do |f|
      f.chmod(0o666)
      f.write(content)
    end
  end

  def self.write_xml(file_name)
    tmpl_path = Rails.root.join("public", "tianwen_tile", "default.xml")
    tmpl = File.open(tmpl_path) { |f| Nokogiri::XML(f) }
    yield tmpl
    xml_to_dir(tmpl.to_xml, file_name)
  end
end
