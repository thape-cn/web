# frozen_string_literal: true

class ResidentialType < ApplicationRecord
  has_many :work_residential_types, dependent: :destroy
  has_many :works, through: :work_residential_types
end
