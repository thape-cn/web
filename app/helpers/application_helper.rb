module ApplicationHelper
  def home_controller
    if browser.ie?
      'home-ie11'
    else
      'home'
    end
  end

  def scroll_controller
    if browser.ie?
      'scroll-ie11'
    else
      'scroll'
    end
  end

  def project_type_path(project_type)
    case project_type.cn_name
    when "居住"
      residential_works_path
    when "展示区/示范区"
      demonstration_zone_works_path
    when "商务办公"
      office_works_path
    when "超高层"
      supertall_works_path
    when "商业空间"
      commercial_works_path
    when "综合体/TOD"
      mixed_used_tod_works_path
    when "文化空间"
      cultural_works_path
    when "医疗康养"
      medical_care_works_path
    when "旅居/酒店"
      hospitality_works_path
    when "教育"
      education_works_path
    when "城市设计/更新"
      urban_design_works_path
    when "城市规划"
      urban_planning_works_path
    when "景观"
      landscape_works_path
    when "室内"
      interior_works_path
    end
  end
end
