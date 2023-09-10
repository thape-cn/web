# frozen_string_literal: true

class SearchController < ApplicationController
  def query
    @city = City.find_by name: params[:q]
    q = Info.sanitize_sql_like(params[:q].presence || params[:b].presence || prams[:k].presence)
    @works_results = if @city.present?
      Work.where(city_id: @city.id).order(position: :asc)
    else
      Work.joins("INNER JOIN work_translations ON work_translations.work_id = works.id")
        .where("work_translations.project_name LIKE ?", "%#{q}%")
        .order(position: :asc)
        .limit(15)
    end
    @people_results = if @city.present?
      Person.includes(:city_people).where(leaving_date: nil).where(city_people: {city_id: @city.id}).order(position: :asc)
    else
      Person.joins("INNER JOIN person_translations ON person_translations.person_id = people.id")
        .where(leaving_date: nil).where("person_translations.name like ?", "%#{q}%").limit(15)
    end

    info_scope = Info.where(hide_in_index_news: false).order(position: :asc).limit(15)

    @info_results_title = info_scope.where("title LIKE ?", "%#{q}%")

    @info_results_introduction = if @info_results_title.present?
      info_scope.where.not(id: @info_results_title.collect(&:id))
    else
      info_scope
    end.where("introduction LIKE ?", "%#{q}%")

    @info_results_content = if @info_results_title.present?
      if @info_results_introduction.present?
        info_scope.where.not(id: @info_results_title.collect(&:id))
          .where.not(id: @info_results_introduction.collect(&:id))
      else
        info_scope.where.not(id: @info_results_title.collect(&:id))
      end
    elsif @info_results_introduction.present?
      info_scope.where.not(id: @info_results_introduction.collect(&:id))
    else
      info_scope
    end.where("content LIKE ?", "%#{q}%")

    if params[:tab].present? && params[:tab] == "work"
      render :works_result
    elsif params[:tab].present? && params[:tab] == "person"
      render :people_result
    elsif params[:tab].present? && params[:tab] == "info"
      render :info_result
    elsif params[:tab].blank? && @works_results.present?
      render :works_result
    elsif params[:tab].blank? && @people_results.present?
      render :people_result
    else
      render :info_result
    end
  end
end
