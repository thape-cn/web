# frozen_string_literal: true

class LeadershipController < ApplicationController
  def index
    @search_name = params[:name].presence
    jituan_people = Person.includes(city_people: :city).where(cities: {name: "集团"})
      .where(leaving_date: nil).order(position: :asc)
    @management_people = if @search_name.present?
      search_name = Person.sanitize_sql_like(@search_name)
      jituan_people.joins("INNER JOIN person_translations ON person_translations.person_id = people.id")
        .where(category: 1).where("person_translations.name LIKE ?", "%#{search_name}%")
    else
      jituan_people.where(category: 1)
    end

    @speciality_people = if @search_name.present?
      search_name = Person.sanitize_sql_like(@search_name)
      jituan_people.joins("INNER JOIN person_translations ON person_translations.person_id = people.id")
        .where(category: 2).where("person_translations.name LIKE ?", "%#{search_name}%")
    else
      jituan_people.where(category: 2)
    end
  end

  def show
    @search_name = params[:name].presence
    city_area = City.find_by url_name: params[:id]
    if city_area.present?
      city_ids = [
        22, # 天华集团
        1, # 上海天华
        7, # 北京天华
        10, # 深圳天华
        12, # 广州天华
        8, # 天津天华
        18, # 重庆天华
        14, # 武汉天华
        19, # 成都天华
        67, # 西北天华
        13, # 沈阳天华
        11, # 厦门天华
        6, # 青岛天华
        3, # 南京天华
        2, # 杭州天华
        4, # 合肥天华
        46, # 贵阳办事处
        45, # 昆明办事处
        44, # 长沙办事处
        47, # 合肥办事处
        29, # 福州天华
        32, # 武汉天华南昌办事处
        74, # AICO - 上海
        75, # AICO - 深圳
        76, # AICO - 香港
        24, # 上海天华规划
        72, # 深圳天华规划
        25, # 天华室内
        26, # 天华景观
        28, # 易术家
        27, # 虹核审图
        60, # 上海天华医养
        79 # 天华嘉易
      ]

      # 分支机构
      @branches = City.where(id: CityPerson.distinct.pluck(:city_id)).where.not(url_name: nil).in_order_of(:id, city_ids).uniq { |city| city.url_name }

      if city_area.url_name.upcase == "AICO"
        people = Person.includes(:city_people).where(leaving_date: nil).order(position: :asc).distinct

        if @search_name.present?
          search_name = Person.sanitize_sql_like(@search_name)
          people = people.joins("INNER JOIN person_translations ON person_translations.person_id = people.id")
            .where("person_translations.name LIKE ?", "%#{search_name}%")
        end

        # AICO上海
        @AICO_SH_people = people.where(city_people: {city_id: 74})

        # AICO深圳
        @AICO_SZ_people = people.where(city_people: {city_id: 75})

        # AICO香港
        @AICO_XG_people = people.where(city_people: {city_id: 76})

        render "aico"
      else
        city_area_people = Person.includes(:city_people).where(city_people: {city_id: city_area.id})
          .where(leaving_date: nil)
          .order(position: :asc)
        city_management_ids = city_area_people.where(city_people: {is_management: true}).pluck(:id)
        city_professional_ids = city_area_people.where(city_people: {is_professional: true}).pluck(:id)
        @management_people = if @search_name.present?
          search_name = Person.sanitize_sql_like(@search_name)
          city_area_people.where(category: 1).or(city_area_people.where(city_people: {is_management: true}))
            .joins("INNER JOIN person_translations ON person_translations.person_id = people.id")
            .where("person_translations.name LIKE ?", "%#{search_name}%")
        else
          city_area_people.where(category: 1).or(city_area_people.where(city_people: {is_management: true}))
        end.where.not(id: city_professional_ids)

        @speciality_people = if @search_name.present?
          search_name = Person.sanitize_sql_like(@search_name)
          city_area_people.where(category: 2).or(city_area_people.where(city_people: {is_professional: true}))
            .joins("INNER JOIN person_translations ON person_translations.person_id = people.id")
            .where("person_translations.name LIKE ?", "%#{search_name}%")
        else
          city_area_people.where(category: 2).or(city_area_people.where(city_people: {is_professional: true}))
        end.where.not(id: city_management_ids)
        e_title = city_area.company_name_english&.upcase

        render "area_leadership", locals: {c: city_area.company_name, city_url_name: city_area.url_name, e_title: e_title, city: city_area}
      end
    else
      @person = Person.where(leaving_date: nil).find_by(id: params[:id]) \
        || Person.where(leaving_date: nil).find_by!(url_name: params[:id])
      @infos = Info.order(position: :asc).where(hide_in_design_staff_news: false).limit(4)
      @infos = @infos.where("title LIKE ?", "%#{@person.name}%").or(@infos.where("content LIKE ?", "%#{@person.name}%"))
    end
  end
end
