# frozen_string_literal: true

class City < ApplicationRecord
  has_many :city_people, dependent: :destroy
  has_many :people, through: :city_people
  has_many :works
end
