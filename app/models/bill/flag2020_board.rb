# frozen_string_literal: true

module Bill
  class Flag2020Board < ApplicationRecord
    after_create :sent_notify, if: proc { |f| f.to_clerkcode.present? }

    private

    def sent_notify
      to_user = Bill::Tianhua2020.find_by clerkcode: to_clerkcode
      from_user = Bill::Tianhua2020.find_by clerkcode: from_clerkcode
      if to_user.wecom_id.present?
        Wechat.api.news_message_send(to_user.wecom_id, "#{from_user.name}立了一个Flag", "他@了你，请你监督",
          "https://www.thape.com/tianhua2020s/#{to_user.clerkcode}/flag_board",
          "https://thape-assets.oss-cn-shanghai.aliyuncs.com/packs/media/images/tianhua2020-notify-2961b89955b3f6cb617a840c06124bda.png")
      end
    rescue Wechat::ResponseError
      true
    end
  end
end
