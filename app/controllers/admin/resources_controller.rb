# frozen_string_literal: true

require "csv"

class Admin::ResourcesController < Admin::ApplicationController
  before_action :set_resource
  before_action :set_record, only: [:show, :edit, :update, :destroy]
  helper_method :admin_order_context, :admin_list_context

  def index
    records = filtered_records
    if @resource.messages? && request.format.csv?
      export_messages(records)
    else
      @records = records.page(admin_list_context["page"]).per(admin_list_context.fetch("per_page", 25))
      if @resource.ordered?
        ids = @resource.scope.order(position: :asc, id: :asc).pluck(:id)
        @order_ranks = ids.each_with_index.to_h.transform_values { |index| index + 1 }
      end
      render "admin/resources/index"
    end
  end

  def show
    render "admin/resources/show"
  end

  def new
    @record = @resource.scope.new
    render "admin/resources/form"
  end

  def edit
    render "admin/resources/form"
  end

  def create
    @record = @resource.scope.new
    save_record
  end

  def update
    save_record
  end

  def reorder
    Admin::Reorder.new(@resource).call(id: params[:id], movement: params[:movement], position: params[:position], target_id: params[:target_id])
    redirect_to reorder_location, notice: "排序已保存", status: :see_other
  rescue Admin::Reorder::InvalidMove => error
    redirect_to reorder_location, alert: error.message, status: :see_other
  end

  def destroy
    if @resource.key == "users" && @record.id == current_admin.id
      redirect_to resource_location, alert: "不能删除当前登录的管理员"
    else
      @record.destroy!
      redirect_to resource_location, notice: "删除成功", status: :see_other
    end
  end

  private

  def set_resource
    @resource = Admin::Resource.new(controller_name)
  end

  def set_record
    @record = if @resource.singleton?
      @resource.scope.first || @resource.scope.new
    else
      @resource.scope.find(params[:id])
    end
  end

  def filtered_records
    records = @resource.scope
    records = records.includes(:translations) if @resource.model.respond_to?(:translated_attribute_names)
    records = records.includes(:project_types, :residential_types) if @resource.key == "works"
    search_field = @resource.search_field
    query = admin_list_context["q"]
    if query.present?
      if @resource.model.respond_to?(:translated_attribute_names) && @resource.model.translated_attribute_names.include?(search_field.to_sym)
        records = records.with_translations(admin_locale)
        table = @resource.model.translation_class.table_name
      else
        table = @resource.model.table_name
      end
      records = records.where("#{table}.#{search_field} ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(query)}%")
    end
    @resource.filters.each_key do |field|
      value = admin_list_context[field]
      next unless value
      records = case [@resource.key, field]
      when ["people", "city_id"]
        records.where(id: ::CityPerson.where(city_id: value).select(:person_id))
      when ["works", "project_type_id"]
        records.where(id: ::WorkProjectType.where(project_type_id: value).select(:work_id))
      when ["works", "published"]
        records.where(published: (value == "true") ? true : [false, nil])
      else
        records.where(field => value)
      end
    end
    order = if @resource.model.column_names.include?("position")
      {position: :asc, id: :asc}
    else
      {id: :desc}
    end
    records.order(order)
  end

  def record_params
    scalar_fields = @resource.fields.reject { |_field, options| options["type"] == "multiple" }.keys
    arrays = @resource.fields.select { |_field, options| options["type"] == "multiple" }.keys.to_h { |field| [field, []] }
    uploads = @resource.fields.select { |_field, options| options["type"] == "file_field" }.keys
    permitted = scalar_fields + uploads.flat_map { |field| ["#{field}_cache", "remove_#{field}"] } + [arrays]
    case @resource.key
    when "works"
      permitted << {work_pictures_attributes: [:id, :album_jpg, :album_webp, :album_jpg_cache, :album_webp_cache, :_destroy]}
    when "people"
      permitted << {city_people_attributes: [:id, :city_title, :city_en_title, :is_management, :is_professional, :_destroy]}
    end
    params.require(@resource.param_key).permit(*permitted).to_h
  end

  def save_record
    @resource.model.transaction do
      attributes = record_params
      remove_deselected_city_roles(attributes) if @resource.key == "people"
      @record.assign_attributes(attributes)
      if @record.new_record? && @resource.key == "infos"
        @record.snapshot_alt = @record.title if @record.snapshot_alt.blank?
        @record.banner_alt = @record.title if @record.banner_alt.blank?
      end
      if @record.new_record? && @resource.ordered?
        @record.position = (@resource.scope.maximum(:position) || -1) + 1
      end
      @record.save!
    end
    redirect_to resource_location, notice: "保存成功", status: :see_other
  rescue ActiveRecord::RecordInvalid
    render "admin/resources/form", status: :unprocessable_entity
  end

  def remove_deselected_city_roles(attributes)
    return unless attributes.key?("city_ids") && attributes["city_people_attributes"].present?
    removed = @record.city_people.where.not(city_id: attributes["city_ids"].reject(&:blank?)).pluck(:id).map(&:to_s)
    attributes["city_people_attributes"].reject! { |_key, role| removed.include?(role["id"].to_s) }
  end

  def resource_location
    if @resource.singleton?
      {controller: "/admin/#{@resource.key}", action: :edit, id: @record&.id || 1}
    else
      {controller: "/admin/#{@resource.key}", action: :index}
    end
  end

  def reorder_location
    resource_location.merge(admin_order_context.symbolize_keys)
  end

  def admin_order_context
    admin_list_context
  end

  def admin_list_context
    @admin_list_context ||= @resource.list_context(params)
  end

  def export_messages(records)
    columns = if @resource.key == "message"
      %w[id company name contact_details message created_at spam_score]
    else
      %w[id company name phone project_type service_type project_area message created_at spam_score]
    end
    headers = if @resource.key == "message"
      %w[序号 公司 姓名 联系方式 留言 留言时间 广告评分]
    else
      %w[序号 公司 姓名 联系电话 项目类型 服务类型 项目面积 合作内容 留言时间 广告评分]
    end
    csv = CSV.generate do |output|
      output << headers
      records.each do |record|
        output << columns.map do |column|
          value = record.public_send(column).to_s
          value.match?(/\A\s*[=+\-@]/) ? "'#{value}" : value
        end
      end
    end
    send_data "\uFEFF#{csv}", type: "text/csv; charset=utf-8", filename: "#{@resource.key}-#{Date.current}.csv"
  end
end
