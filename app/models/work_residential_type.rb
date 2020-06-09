class WorkResidentialType < ApplicationRecord
  belongs_to :work
  belongs_to :residential_type
end
