# frozen_string_literal: true

require 'csv'

namespace :tianhua_bill do
  desc 'Import the tianhua 2020'
  task :import_tianhua2020_data, [:csv_file_path] => [:environment] do |_task, args|
    csv_file_path = args[:csv_file_path]
    Bill::Tianhua2020.delete_all
    CSV.foreach(csv_file_path, headers: true) do |csv|
      Bill::Tianhua2020.create(csv.to_hash)
    end
  end

  desc 'Sent tianhua 2020 bill notification'
  task sent_2020_notification: :environment do |_task, args|
    Bill::Tianhua2020.all.order(clerkcode: :desc).find_each do |t|
      next if t.wecom_id.blank?
      wechar_user_id = t.wecom_id
      puts "#{t.clerkcode}: #{t.name} #{wechar_user_id}"
      Wechat.api.news_message_send(wechar_user_id, "#{t.name}的天华年度账单", '可以发到朋友圈让大家一起回顾2020',
          "https://www.thape.com/tianhua2020s/#{t.clerkcode}",
          'https://thape-assets.oss-cn-shanghai.aliyuncs.com/packs/media/images/tianhua2020-banner-34d2d5c41a7c6714f1238dda9bb38ef7.png')
    rescue Wechat::ResponseError
      puts "#{t.name} wechar_user_id error: #{wechar_user_id}"
    end
  end
end
