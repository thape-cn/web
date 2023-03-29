# frozen_string_literal: true

class Api::ZnzmosController < ApplicationController
  def create
    z = Znzmo.find_or_initialize_by(url: params[:url])
    z.keywords = params[:keywords]
    z.user_id = params[:user_id]
    z.view_count = params[:view_count]
    z.download_count = params[:download_count]
    z.update_time = params[:update_time]
    z.design_date = params[:design_date]
    z.design_style = params[:design_style]
    z.file_type = params[:file_type]
    z.file_page_num = params[:file_page_num]
    z.designer = params[:designer]
    z.developer = params[:developer]
    z.project_area = params[:project_area]
    z.official_subsidy_price = params[:official_subsidy_price]
    z.vip_price = params[:vip_price]
    z.save
  end
end
