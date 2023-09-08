# frozen_string_literal: true

class Api::WorksController < ApplicationController
  def index
    works = Work.select(:id)
    works_with_q = if params[:q].present?
      q = Work.sanitize_sql_like(params[:q])
      works.joins(:translations).where("work_translations.project_name LIKE ?", "%#{q}%")
    else
      works
    end
    @total = works_with_q.count
    @works = Work.where(Work.arel_table[:id].in(works_with_q.pluck(:id))).includes(:translations).order(position: :asc)
      .page(params[:page]).per(params[:per_page])
  end

  def show
    @work = Work.find params[:id]
  end
end
