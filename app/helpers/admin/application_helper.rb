# frozen_string_literal: true

module Admin::ApplicationHelper
  NAVIGATION_GROUPS = [
    {label: "内容管理", keys: %w[works cases infos people]},
    {label: "官网页面", keys: %w[tail_homes about_pages work_type_pages service_files]},
    {label: "出版与资料", keys: %w[publications portfolios insights pictures]},
    {label: "联系与设置", keys: %w[message project_messages cities map_contacts seos users]},
    {label: "旧版页面", keys: %w[home about]}
  ].freeze

  RESOURCE_PRESENTATION = {
    "works" => ["building", "维护官网作品、项目分类与图片"],
    "cases" => ["building", "管理经典项目与案例图库"],
    "infos" => ["news", "发布公司动态、行业会议与专业奖项"],
    "people" => ["people", "维护团队成员、个人介绍与城市职位"],
    "tail_homes" => ["home", "更新首页项目、新闻与展示图片"],
    "about_pages" => ["page", "维护公司介绍与品牌内容"],
    "work_type_pages" => ["grid", "维护作品分类页面与展示内容"],
    "service_files" => ["folder", "更新专业服务介绍与相关资料"],
    "publications" => ["book", "管理专著、标准规范与论文专利"],
    "portfolios" => ["folder", "维护作品集、封面与 PDF 文件"],
    "insights" => ["book", "管理天华内刊与阅读资料"],
    "pictures" => ["image", "上传和管理网站图片资源"],
    "message" => ["message", "查看客户留言与联系方式"],
    "project_messages" => ["message", "查看项目合作需求与咨询信息"],
    "cities" => ["pin", "维护城市名称与区域信息"],
    "map_contacts" => ["pin", "更新子公司地址与联系电话"],
    "seos" => ["search", "设置页面标题、关键词与描述"],
    "users" => ["people", "管理网站后台的管理员账号"],
    "home" => ["home", "维护旧版首页的轮播与推荐内容"],
    "about" => ["page", "维护旧版关于天华页面"]
  }.freeze

  ICON_PATHS = {
    "grid" => "M3 3h7v7H3z M14 3h7v7h-7z M3 14h7v7H3z M14 14h7v7h-7z",
    "home" => "m3 10 9-7 9 7 M5 9v12h5v-7h4v7h5V9",
    "building" => "M3 21h18 M5 21V7l8-4v18 M13 9h6v12 M8 9h2 M8 13h2 M8 17h2 M16 12h1 M16 16h1",
    "news" => "M4 3h16v18H4z M7 7h10 M7 11h4v4H7z M14 11h3 M14 15h3 M7 18h10",
    "people" => "M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2 M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8 M17 4a4 4 0 0 1 0 7 M22 21v-2a4 4 0 0 0-3-3.87",
    "page" => "M14 2H5v20h14V7z M14 2v5h5 M8 12h8 M8 16h8",
    "folder" => "M3 7V4h6l3 3h9v13H3z",
    "book" => "M12 5C8 2 4 3 2 4v16c3-2 7-2 10 0 3-2 7-2 10 0V4c-2-1-6-2-10 1z M12 5v15",
    "image" => "M3 3h18v18H3z m0 14 5-5 4 4 3-3 6 6 M16 7h.01",
    "message" => "M21 15a3 3 0 0 1-3 3H8l-5 3V6a3 3 0 0 1 3-3h12a3 3 0 0 1 3 3z M7 8h10 M7 12h6",
    "pin" => "M20 10c0 6-8 12-8 12S4 16 4 10a8 8 0 1 1 16 0z M15 10a3 3 0 1 0-6 0 3 3 0 0 0 6 0",
    "search" => "M16 10a6 6 0 1 0-12 0 6 6 0 0 0 12 0 m-2 4 6 6",
    "arrow" => "M5 12h14 m-6-6 6 6-6 6",
    "external" => "M14 3h7v7 M21 3 10 14 M10 3H3v18h18v-7",
    "plus" => "M12 5v14 M5 12h14",
    "download" => "M12 3v12 m-5-5 5 5 5-5 M4 16v5h16v-5",
    "menu" => "M4 6h16 M4 12h16 M4 18h16",
    "close" => "m6 6 12 12 M6 18 18 6",
    "check" => "m5 12 4 4L19 6",
    "alert" => "M12 8v5 M12 17h.01 M12 3 2 21h20z",
    "logout" => "M9 4H3v16h6 M9 12h12 m-5-5 5 5-5 5"
  }.freeze

  def admin_navigation_groups
    NAVIGATION_GROUPS.map { |group| group.merge(resources: group[:keys].map { |key| Admin::Resource.new(key) }) }
  end

  def admin_resource_description(resource)
    RESOURCE_PRESENTATION.fetch(resource.key).last
  end

  def admin_resource_icon(resource)
    admin_icon(RESOURCE_PRESENTATION.fetch(resource.key).first)
  end

  def admin_icon(name, **options)
    tag.svg(viewBox: "0 0 24 24", fill: "none", stroke: "currentColor", "stroke-width": 1.5, "stroke-linecap": "round", "stroke-linejoin": "round", aria: {hidden: true}, class: options.fetch(:class, "admin-icon")) do
      tag.path(d: ICON_PATHS.fetch(name))
    end
  end

  def admin_locale_label
    (admin_locale == "cn") ? "中文" : "English"
  end

  def admin_back_path(resource)
    resource.singleton? ? admin_root_path : admin_resource_path(resource)
  end

  def admin_status(record, field)
    value = record.public_send(field)
    label = if field == "published"
      value ? "已发布" : "未发布"
    else
      admin_display(record, field)
    end
    tag.span(label, class: "admin-badge #{value ? "admin-badge-positive" : "admin-badge-neutral"}")
  end

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
    link = link_to(upload.identifier, upload.url, target: "_blank", rel: "noopener", class: "admin-link break-all text-xs")
    if upload.identifier.to_s.match?(/\.(jpe?g|png|gif|webp)\z/i)
      safe_join([image_tag(upload.url, alt: upload.identifier, class: "admin-preview"), link])
    else
      link
    end
  end
end
