class ProjectType < ApplicationRecord
  has_many :work_project_types, dependent: :destroy
  has_many :works, through: :work_project_types
end
