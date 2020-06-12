class SearchController < ApplicationController
  def query
    @works_results = Work.joins('INNER JOIN work_translations ON work_translations.work_id = works.id')
      .where('work_translations.project_name LIKE ?', "%#{params[:q]}%").limit(15)
    @people_results = Person.joins('INNER JOIN person_translations ON person_translations.person_id = people.id')
      .where('person_translations.name like ?', "%#{params[:q]}%").limit(15)
    @info_results = Info.where('title LIKE ?', "%#{params[:q]}%").order(position: :asc).limit(15)

    if @works_results.present? && (params[:tab].blank? || params[:tab] == 'work')
      render :works_result
    elsif @people_results.present? && (params[:tab].blank? || params[:tab] == 'person')
      render :people_result
    else
      render :info_result
    end
  end
end
