# frozen_string_literal: true

namespace :ai do
  desc "Mark guest message spam score"
  task mark_spam_message: :environment do
    m = GuestMessage.find 2009
    puts "#{m.name}:#{m.message}"
    ai_result = JSON.parse(m.spam_score)

    if ai_result.present?
      spam_score = ai_result["spam_score"]
      puts "spam_score: #{spam_score}"
    end
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
