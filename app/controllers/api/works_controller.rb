# frozen_string_literal: true

class Api::WorksController < ApplicationController
  def index
    works = Work.includes(:translations).order(position: :asc).where(published: true)
    @works = if params[:q].present?
      works.where('work_translations.project_name LIKE ?', "%#{params[:q]}%")
    else
      works
    end.page(params[:page]).per(params[:per_page])
  end

  def show
    @work = Work.find params[:id]
  end
end
