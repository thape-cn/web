# frozen_string_literal: true

module Admin::ApplicationHelper
  def admin_resource_path(resource, action = nil, record = nil, **options)
    action ||= resource.singleton? ? :edit : :index
    id = record&.id
    id ||= 1 if resource.singleton? && %w[home about service_files].include?(resource.key)
    url_for({controller: "/admin/#{resource.key}", action: action, id: id, only_path: true}.merge(options))
  end

  def admin_field_label(resource, field)
    resource.fields.dig(field, "label") || {"id" => "ID", "created_at" => "留言时间", "spam_score" => "广告评分", "company" => "公司", "name" => "姓名", "message" => "留言", "phone" => "联系电话", "contact_details" => "联系方式", "project_type" => "项目类型", "service_type" => "服务类型", "project_area" => "项目面积", "seo_name" => "页面"}[field] || field.humanize
  end

  def admin_options(resource, field)
    case [resource.key, field]
    when ["people", "category"] then [["管理团队", 1], ["专业团队", 2]]
    when ["infos", "category"] then [["公司新闻", 1], ["行业会议", 2], ["专业奖项", 3]]
    when ["works", "city_id"], ["people", "city_ids"] then ::City.order(:id).pluck(:name, :id)
    when ["works", "project_type_ids"] then ::ProjectType.order(:id).pluck(:cn_name, :id)
    when ["works", "residential_type_ids"] then ::ResidentialType.order(:id).pluck(:cn_name, :id)
    when ["cases", "professional"] then Admin::Case.professional_options
    when ["cases", "market"] then Admin::Case.market_options
    when ["publications", "category_status"] then [["专著", "monographs"], ["标准规范", "standard_specification"], ["论文专利", "paper_patent"]]
    else []
    end
  end

  def admin_display(record, field)
    value = record.public_send(field)
    resource = @resource
    if resource && %w[select multiple].include?(resource.fields.dig(field, "type"))
      values = Array(value).map(&:to_s)
      values = value.to_s.scan(/\d+/) if resource.key == "cases"
      labels = admin_options(resource, field).filter_map { |label, id| label if values.include?(id.to_s) }
      return labels.join("、").presence || "—"
    end
    return "是" if value == true
    return "否" if value == false
    return value.strftime("%Y-%m-%d %H:%M") if value.respond_to?(:strftime)
    value.to_s.presence || "—"
  end

  def admin_upload_preview(upload)
    return unless upload.present? && upload.url.present?
    link = link_to(upload.identifier, upload.url, target: "_blank", rel: "noopener", class: "text-blue-700 break-all")
    if upload.identifier.to_s.match?(/\.(jpe?g|png|gif|webp)\z/i)
      safe_join([image_tag(upload.url, alt: upload.identifier, class: "admin-preview"), link])
    else
      link
    end
  end
end
