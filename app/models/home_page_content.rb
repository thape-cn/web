class HomePageContent < ApplicationRecord
  has_one :work_1, class_name: 'Work', foreign_key: :id, primary_key: :work_1_id
  has_one :work_2, class_name: 'Work', foreign_key: :id, primary_key: :work_2_id
  has_one :work_3, class_name: 'Work', foreign_key: :id, primary_key: :work_3_id
  has_one :work_4, class_name: 'Work', foreign_key: :id, primary_key: :work_4_id
  has_one :work_5, class_name: 'Work', foreign_key: :id, primary_key: :work_5_id
  has_one :work_6, class_name: 'Work', foreign_key: :id, primary_key: :work_6_id

  has_one :news_1, class_name: 'Info', foreign_key: :id, primary_key: :news_1_id
  has_one :news_2, class_name: 'Info', foreign_key: :id, primary_key: :news_2_id
  has_one :news_3, class_name: 'Info', foreign_key: :id, primary_key: :news_3_id
end
