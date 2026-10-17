# frozen_string_literal: true

require "cgi"
require "uri"

class CreatePictureReferences < ActiveRecord::Migration[7.2]
  # Keep the backfill independent of application models and their callbacks.
  SOURCES = {
    "infos" => ["Info", "id", nil, %w[introduction content]],
    "person_translations" => ["Person", "person_id", "locale", %w[title introduce]],
    "work_translations" => ["Work", "work_id", "locale", %w[design_completion_lines client construction_completion_lines services team cooperation awards architecture_area_lines]],
    "about_page_translations" => ["AboutPage", "about_page_id", "locale", %w[thape_intro]],
    "service_file_translations" => ["ServiceFile", "service_file_id", "locale", %w[building_intro interior_intro planning_intro landscape_intro vetting_intro consluting_intro vrtech_intro sustainable_intro]],
    "seos" => ["Seo", "id", nil, %w[description abstract keywords]]
  }.freeze
  IMAGE_REFERENCE = %r{/uploads/picture/image/(\d+)/([^/"'<>?\#\s)]+)}

  def up
    create_table :picture_references do |t|
      t.references :picture, null: false, foreign_key: {on_delete: :cascade}
      t.references :owner, null: false, polymorphic: true
      t.string :field, null: false
      t.string :locale, null: false, default: ""
      t.index [:picture_id, :owner_type, :owner_id, :field, :locale], unique: true, name: "index_picture_references_on_usage"
    end
    backfill_references
  end

  def down
    drop_table :picture_references
  end

  private

  def backfill_references
    pictures = connection.select_rows("SELECT id, image FROM pictures").to_h
    references = Class.new(ActiveRecord::Base) { self.table_name = "picture_references" }
    SOURCES.each do |table, (type, owner_column, locale_column, fields)|
      columns = [owner_column, locale_column, *fields].compact.map { |column| connection.quote_column_name(column) }
      conditions = fields.map { |field| "#{connection.quote_column_name(field)} LIKE '%/uploads/picture/image/%'" }
      rows = connection.select_rows("SELECT #{columns.join(", ")} FROM #{connection.quote_table_name(table)} WHERE #{conditions.join(" OR ")}")
      attributes = rows.flat_map do |row|
        owner_id = row.shift
        locale = locale_column ? row.shift.to_s : ""
        fields.zip(row).flat_map do |field, content|
          CGI.unescapeHTML(content.to_s).scan(IMAGE_REFERENCE).uniq.filter_map do |id, filename|
            picture_id = id.to_i
            next unless pictures[picture_id].present? && pictures[picture_id] == URI::DEFAULT_PARSER.unescape(filename)

            {picture_id: picture_id, owner_type: type, owner_id: owner_id, field: field, locale: locale}
          end
        end
      end
      attributes.each_slice(1000) { |batch| references.insert_all(batch, unique_by: :index_picture_references_on_usage) }
    end
  end
end
