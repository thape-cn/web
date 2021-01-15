# frozen_string_literal: true

class WorkProjectType < ApplicationRecord
  belongs_to :work
  belongs_to :project_type
end
