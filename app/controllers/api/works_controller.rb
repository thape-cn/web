# frozen_string_literal: true

class Api::WorksController < ApplicationController
  def index
    works = Work.includes(:translations).order(position: :asc).where(published: true)
    works_with_q = if params[:q].present?
      works.joins(:translations).where('work_translations.project_name LIKE ?', "%#{params[:q]}%")
    else
      works
    end
    @total = works_with_q.count
    @works = works_with_q.page(params[:page]).per(params[:per_page])
  end

  def show
    @work = Work.find params[:id]
  end
end
