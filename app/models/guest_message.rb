# frozen_string_literal: true

class GuestMessage < ApplicationRecord
  def spam_score
    system_prompt = <<~EOS_PROMPT # Disabled interpolation
      User will provide some guest message text from a 上海天华建筑设计有限公司官网 天华集团.
      Please read, understand what the guest want from the webmaster perspective, output spam score (range from 0 to 10, 10 means message is fully spam) in JSON format.
      If you can not determine whether it is spam or not, just return 5.
      
      
      EXAMPLE INPUT 1:
      包淦: 请问贵阳公司在招结构专业负责人吗
      
      EXAMPLE JSON OUTPUT 1:
      {
          "spam_score": 0
      }
      
      EXAMPLE INPUT 2:
      DavidPop: Igjdfjvkdgvj jfsfcjsjfkj ifjfsifhidjfw iijfosjfd https://mail.ru/?gjvhdfjdfuvdbggf
      
      EXAMPLE JSON OUTPUT 2:
      {
          "spam_score": 10
      }
      
      EXAMPLE INPUT 3:
      RobertDrale:Hæ, ég vildi vita verð þitt.
      
      EXAMPLE JSON OUTPUT 3:
      {
          "spam_score": 5
      }
      
      EXAMPLE INPUT 4:
      Eric Jones: Cool website!
      
      My name's Eric, and I just found your site - thape.com - while surfing the net. You showed up at the top of the search results, so I checked you out. Looks like what you're doing is pretty cool.
      
      If you'd like to unsubscribe click here http://talkwithcustomer.com/unsubscribe.aspx?d=thape.com
      
      
      EXAMPLE JSON OUTPUT 4:
      {
          "spam_score": 9
      }
      
    EOS_PROMPT

    response = OpenAI::Client.new.chat(
      parameters: {
        model: "deepseek-chat",
        response_format: {type: "json_object"},
        messages: [{role: "system", content: system_prompt},
          {role: "user", content: "#{name}:#{message}"}],
        temperature: 0.7
      }
    )
    response.dig("choices", 0, "message", "content")
  end
end
