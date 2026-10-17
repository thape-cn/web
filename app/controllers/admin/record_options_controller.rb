# frozen_string_literal: true

class Admin::RecordOptionsController < Admin::ApplicationController
  def index
    valid_resource = Admin::RecordOptions::SOURCES.key?(params[:resource])
    valid_query = params[:q].nil? || params[:q].is_a?(String)
    return head :bad_request unless valid_resource && valid_query

    response.headers["Cache-Control"] = "no-store"
    render json: {options: Admin::RecordOptions.new(params[:resource], locale: admin_locale).search(params[:q].to_s)}
  end
end
