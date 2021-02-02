class Api::WorksController < ApplicationController
  def index
    @works = Work.joins('INNER JOIN work_translations ON work_translations.work_id = works.id')
        .order(position: :asc)
        .distinct.where(published: true)
    if params[:q].present?
      @works = @works.where('work_translations.project_name LIKE ?', "%#{params[:q]}%")
    end
    @total = @works.count
    @works = @works.page(params[:page]).per(params[:per_page])
  end
end
