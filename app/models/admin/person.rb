# frozen_string_literal: true

class Admin::Person < ::Person
  include Admin::Uploads

  accepts_nested_attributes_for :city_people, allow_destroy: true
  preserve_upload_paths
end
