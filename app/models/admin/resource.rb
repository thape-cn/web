# frozen_string_literal: true

class Admin::Resource
  DEFINITIONS = JSON.parse(Rails.root.join("config/admin/resources.json").read).freeze
  SEARCH_FIELDS = {"works" => "project_name", "people" => "name", "infos" => "title", "publications" => "title", "portfolios" => "title", "insights" => "title"}.freeze
  FILTERS = {
    "works" => {"published" => "发布状态", "city_id" => "城市", "project_type_id" => "项目分类"},
    "people" => {"category" => "团队分类", "city_id" => "城市"},
    "infos" => {"category" => "新闻分类"},
    "publications" => {"category_status" => "分类"}
  }.freeze

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
    %w[infos insights people portfolios publications works].include?(key)
  end

  def messages?
    %w[message project_messages].include?(key)
  end

  def scope
    model.unscoped
  end

  def search_field
    SEARCH_FIELDS[key]
  end

  def filters
    FILTERS.fetch(key, {})
  end

  def filter_options(field)
    @filter_options ||= {}
    @filter_options[field] ||= case field
    when "published" then [["已发布", "true"], ["未发布", "false"]]
    when "city_id" then ::City.order(:id).pluck(:name, :id)
    when "project_type_id" then ::ProjectType.order(:id).pluck(:cn_name, :id)
    when "category_status" then [["专著", "monographs"], ["标准规范", "standard_specification"], ["论文专利", "paper_patent"]]
    when "category"
      (key == "people") ? [["管理团队", 1], ["专业团队", 2]] : [["公司新闻", 1], ["行业会议", 2], ["专业奖项", 3]]
    else []
    end
  end

  # Only recognized, valid list parameters travel between links and reorder forms.
  def list_context(params)
    context = {}
    if search_field
      query = params[:q].presence || params[search_field].presence
      context["q"] = query.to_s if query.is_a?(String)
    end
    filters.each_key do |field|
      value = params[field]
      context[field] = value.to_s if filter_options(field).any? { |_, option| option.to_s == value.to_s }
    end
    %w[page per_page].each do |field|
      value = params[field].to_s
      context[field] = ((field == "per_page") ? value.to_i.clamp(1, 100) : [value.to_i, 1].max).to_s if value.match?(/\A\d+\z/)
    end
    context["view"] = params[:view] if key == "pictures" && %w[grid list].include?(params[:view])
    context
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
