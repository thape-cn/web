# frozen_string_literal: true

class ProjectMessagesController < ApplicationController
  def create
    @project_message = ProjectMessage.create(project_message_params)

    respond_to do |format|
      format.js
      format.html { redirect_to biz_map_path }
    end
  end

  private

  def project_message_params
    params.require(:project_message)
      .permit(:name, :phone, :company, :project_type, :service_type, :project_area, :message)
  end
end
