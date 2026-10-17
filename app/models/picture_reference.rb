# frozen_string_literal: true

require "cgi"
require "uri"

class PictureReference < ApplicationRecord
  CONTENT_FIELDS = {
    "Info" => %w[introduction content],
    "Person" => %w[title introduce],
    "Work" => %w[design_completion_lines client construction_completion_lines services team cooperation awards architecture_area_lines],
    "AboutPage" => %w[thape_intro],
    "ServiceFile" => %w[building_intro interior_intro planning_intro landscape_intro vetting_intro consluting_intro vrtech_intro sustainable_intro],
    "Seo" => %w[description abstract keywords]
  }.freeze
  IMAGE_REFERENCE = %r{/uploads/picture/image/(\d+)/([^/"'<>?\#\s)]+)}

  belongs_to :picture
  belongs_to :owner, -> { unscope(where: :published) }, polymorphic: true

  def self.extract(content)
    CGI.unescapeHTML(content.to_s).scan(IMAGE_REFERENCE).map do |id, filename|
      [id.to_i, URI::DEFAULT_PARSER.unescape(filename)]
    end.uniq
  end

  def self.sync_for(owner)
    type = owner.class.base_class.name
    fields = CONTENT_FIELDS.fetch(type)
    translated = owner.class.respond_to?(:translated_attribute_names) ? fields & owner.class.translated_attribute_names.map(&:to_s) : []
    sources = [[owner, fields - translated, ""]]
    if translated.any?
      sources.concat(owner.translations.reload.map { |translation| [translation, translated, translation.locale.to_s] })
    end
    candidates = sources.flat_map do |source, source_fields, locale|
      source_fields.flat_map do |field|
        extract(source[field]).map { |id, filename| [id, filename, field, locale] }
      end
    end
    pictures = Picture.where(id: candidates.map(&:first)).pluck(:id, :image).to_h
    rows = candidates.filter_map do |id, filename, field, locale|
      next unless pictures[id].present? && pictures[id] == filename

      {picture_id: id, owner_type: type, owner_id: owner.id, field: field, locale: locale}
    end
    transaction do
      where(owner_type: type, owner_id: owner.id).delete_all
      insert_all!(rows) if rows.any?
    end
  end
end
