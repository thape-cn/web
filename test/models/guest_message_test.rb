# frozen_string_literal: true

require "test_helper"

class GuestMessageTest < ActiveSupport::TestCase
  test "does not use AI scoring when DeepSeek is not configured" do
    RubyLLM.config.stub(:deepseek_api_key, nil) do
      message = GuestMessage.create!(id: 10_001, name: "Guest", company: "Company", message: "Hello")

      assert_nil message.reload.spam_score
    end
  end

  test "does not overwrite an explicitly provided spam score" do
    RubyLLM.config.stub(:deepseek_api_key, "test-key") do
      message = GuestMessage.create!(id: 10_002, name: "Guest", company: "Company", message: "Hello", spam_score: 7)

      assert_equal 7, message.reload.spam_score
    end
  end
end
