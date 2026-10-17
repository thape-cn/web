# frozen_string_literal: true

class Admin::RecordOptions
  SOURCES = {"works" => [Admin::Work, "project_name"], "infos" => [Admin::Info, "title"]}.freeze

  def initialize(resource, locale:)
    @model, @field = SOURCES.fetch(resource)
    @locale = locale
  end

  def search(query)
    records = @model.unscoped
    query = query.strip.first(200)
    if query.match?(/\A#?\d+\z/)
      records = records.where(id: query.delete_prefix("#"))
    elsif query.present?
      match = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
      records = if @model.respond_to?(:translated_attribute_names) && @model.translated_attribute_names.include?(@field.to_sym)
        records.where(id: @model.translation_class.where(locale: @locale).where("#{@field} ILIKE ?", match).select(@model.reflect_on_association(:translations).foreign_key))
      else
        records.where("#{@field} ILIKE ?", match)
      end
    end
    records = records.includes(:translations) if @model.respond_to?(:translated_attribute_names)
    records.order(id: :desc).limit(20).map { |record| option(record) }
  end

  def selected(id)
    record = @model.unscoped.find_by(id: id) if id.present?
    option(record) if record
  end

  private

  def option(record)
    I18n.with_locale(@locale) do
      {id: record.id, label: record.public_send(@field).presence || I18n.t("admin.record_picker.untitled"), published: (@model == Admin::Work) ? !!record.published : nil}
    end
  end
end
