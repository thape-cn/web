# frozen_string_literal: true

class Admin::Resource
  DEFINITIONS = JSON.parse(Rails.root.join("config/admin/resources.json").read).freeze

  attr_reader :key, :definition

  def self.all
    DEFINITIONS.keys.map { |key| new(key) }
  end

  def initialize(key)
    @key = key
    @definition = DEFINITIONS.fetch(key)
  end

  def model
    definition.fetch("model").constantize
  end

  def label
    definition.fetch("label")
  end

  def param_key
    definition.fetch("param")
  end

  def fields
    definition.fetch("fields")
  end

  def singleton?
    definition.fetch("singleton")
  end

  def allows?(action)
    definition.fetch("actions").include?(action.to_s)
  end

  def ordered?
    %w[works people cases].include?(key)
  end

  def messages?
    %w[message project_messages].include?(key)
  end

  def scope
    model.unscoped
  end

  def columns
    return %w[id name email] if key == "users"
    return %w[id name company created_at spam_score] if messages?
    return %w[id seo_name home_title] if key == "seos"
    return %w[id project_name project_type_ids residential_type_ids published] if key == "works"
    return %w[id name url_name category leaving_date] if key == "people"
    return %w[id title category hide_in_index_news created_at] if key == "infos"
    return %w[id image info_id] if key == "pictures"
    return %w[id title sub_title pdf_file cover_jpg] if %w[publications portfolios insights].include?(key)
    (["id"] + fields.keys.reject { |field| %w[password_field file_field text_area multiple].include?(fields[field]["type"]) }.first(5)).uniq
  end
end
