# frozen_string_literal: true

require "test_helper"

class ProjectMessagesControllerTest < ActionDispatch::IntegrationTest
  test "creates project message with selected text values" do
    notification = nil
    response = Struct.new(:success?, :status).new(true, 200)

    faraday_post = lambda do |*arguments|
      notification = arguments
      response
    end

    Faraday.stub(:post, faraday_post) do
      assert_difference("ProjectMessage.count") do
        post project_messages_path, params: {
          project_message: {
            name: "张三",
            phone: "13800138000",
            company: "天华测试",
            project_type: "住宅、商业",
            service_type: "方案、施工图",
            project_area: "10000",
            message: "项目合作信息"
          }
        }
      end
    end

    project_message = ProjectMessage.order(:created_at).last
    assert_equal "住宅、商业", project_message.project_type
    assert_equal "方案、施工图", project_message.service_type
    assert_equal Rails.application.credentials.cybros_notification_url, notification.first
    payload = JSON.parse(notification.second)
    assert_equal Rails.application.credentials.project_message_secret, payload["secret"]
    assert_equal "张三", payload.dig("project_message", "name")
    assert_equal project_message.created_at.iso8601(3), payload.dig("project_message", "created_at")
    assert_redirected_to biz_map_path
  end
end
