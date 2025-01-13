# frozen_string_literal: true

namespace :ai do
  desc "JSON return test"
  task json_test: :environment do
    response = OpenAI::Client.new.chat(
      parameters: {
        model: "deepseek-chat",
        response_format: { type: "json_object" },
        messages: [{ role: "user", content: "Hello! Give me some JSON please."}],
        temperature: 0.7,
      })
    puts response.dig("choices", 0, "message", "content")
  end
end
