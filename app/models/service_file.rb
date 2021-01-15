# frozen_string_literal: true

class ServiceFile < ApplicationRecord
  translates :building_intro, :interior_intro, :planning_intro, :landscape_intro, :vetting_intro, :consluting_intro, :vrtech_intro

  mount_uploader :interior_intro_file, ServiceFileUploader
end
