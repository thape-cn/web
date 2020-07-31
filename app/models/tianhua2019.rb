class Tianhua2019 < ApplicationRecord
  establish_connection :tianhua2019 unless Rails.env.test?
end
