# frozen_string_literal: true

class ProjectMessagesController < ApplicationController
  def create
    @project_message = ProjectMessage.create(project_message_params)
    notify_cybros if @project_message.persisted?

    respond_to do |format|
      format.js
      format.html { redirect_to biz_map_path }
    end
  end

  private

  def notify_cybros
    response = Faraday.post(
      Rails.application.credentials.cybros_notification_url,
      {
        secret: Rails.application.credentials.project_message_secret,
        project_message: @project_message.as_json(only: %i[
          name phone company project_type service_type project_area message
          spam_score created_at updated_at
        ])
      }.to_json,
      "Content-Type" => "application/json"
    ) do |request|
      request.options.open_timeout = 2
      request.options.timeout = 5
    end

    return if response.success?

    Rails.logger.error("Cybros project message notification failed with HTTP #{response.status}")
  rescue Faraday::Error => e
    Rails.logger.error("Cybros project message notification failed: #{e.message}")
  end

  def project_message_params
    params.require(:project_message)
      .permit(:name, :phone, :company, :project_type, :service_type, :project_area, :message)
  end
end
