# frozen_string_literal: true

namespace :ai do
  desc "Mark guest message spam score"
  task mark_spam_message: :environment do
    GuestMessage.where(spam_score: nil).find_each do |m|
      ai_result = JSON.parse(m.spam_score)

      if ai_result.present?
        spam_score = ai_result["spam_score"]
        puts "#{m.id}:#{m.name} spam_score: #{spam_score}"
        m.update_column(:spam_score, spam_score)
      end
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
