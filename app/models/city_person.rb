class CityPerson < ApplicationRecord
  belongs_to :person
  belongs_to :city
end
