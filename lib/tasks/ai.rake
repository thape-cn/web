# frozen_string_literal: true

namespace :ai do
  desc "Mark guest message spam score"
  task mark_spam_message: :environment do
    m = GuestMessage.find 2007
    puts m.spam_score
  end

  desc "JSON return test"
  task json_test: :environment do
    response = OpenAI::Client.new.chat(
      parameters: {
        model: "deepseek-chat",
        response_format: {type: "json_object"},
        messages: [{role: "user", content: "Hello! Give me some JSON please."}],
        temperature: 0.7
      }
    )
    puts response.dig("choices", 0, "message", "content")
  end
end
