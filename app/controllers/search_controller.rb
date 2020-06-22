class SearchController < ApplicationController
  def query
    @works_results = Work.joins('INNER JOIN work_translations ON work_translations.work_id = works.id')
      .where('work_translations.project_name LIKE ?', "%#{params[:q]}%").limit(15)
    city = City.find_by name: params[:q]
    @people_results = Person.joins('INNER JOIN person_translations ON person_translations.person_id = people.id')
          .where('person_translations.name like ?', "%#{params[:q]}%").limit(15)
    @people_city_results = if city.present?
      Person.includes(:city_people).where(city_people: {city_id: city.id}).order(position: :asc)
    else
      []
    end

    @info_results = Info.where('title LIKE ?', "%#{params[:q]}%").order(position: :asc).limit(15)

    if params[:tab].present? && params[:tab] == 'work'
      render :works_result
    elsif params[:tab].present? && params[:tab] == 'person'
      render :people_result
    elsif params[:tab].present? && params[:tab] == 'info'
      render :info_result
    elsif params[:tab].blank? && @works_results.present?
      render :works_result
    elsif params[:tab].blank? && (@people_results.present? || @people_city_results.present?)
      render :people_result
    else
      render :info_result
    end
  end
end
