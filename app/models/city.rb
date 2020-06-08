class City < ApplicationRecord
  has_many :city_people, dependent: :destroy
  has_many :people, through: :city_people
end
