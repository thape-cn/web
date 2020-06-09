class Work < ApplicationRecord
  has_many :work_project_types, dependent: :destroy
  has_many :project_types, through: :work_project_types
  belongs_to :city

  translates :project_name, :client, :services, :team, :cooperation, :awards
end
