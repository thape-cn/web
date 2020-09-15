module ApplicationHelper
  def full_title(page_title = '')
    base_title = "天华建筑设计公司官网"
    if page_title.empty?
      base_title
    else
      page_title + " - " + base_title
    end
  end

  def person_titles(person, city)
    city_person = person.city_people.find_by(city_id: city&.id)
    person_titles = person.title&.split(' ') || []
    if city_person.present? && city_person.city_title.present?
      if I18n.locale == :en
        person_titles.unshift(city_person.city_en_title).uniq
      else
        person_titles.unshift(city_person.city_title).uniq
      end
    else
      person_titles
    end
  end

  # Font dual size helper
  def fdsz(normal_class, big_size_class = nil)
    if cookies['ts'] == 'big'
      big_size_class || normal_class
    else
      normal_class
    end
  end

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

  def search_form_project_type_width(project_type_name)
    return 'w-56' if I18n.locale == :en
    case project_type_name
    when "展示区/示范区"
      'w-48'
    when "城市设计/更新"
    when "综合体/TOD"
      'w-40'
    else
      'w-32'
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
