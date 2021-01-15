# frozen_string_literal: true

class WorkTypePage < ApplicationRecord
  mount_uploader :resdential_jpg, PictureUploader
  mount_uploader :resdential_webp, PictureUploader
  mount_uploader :demonstration_zone_jpg, PictureUploader
  mount_uploader :demonstration_zone_webp, PictureUploader
  mount_uploader :mixed_used_tod_jpg, PictureUploader
  mount_uploader :mixed_used_tod_webp, PictureUploader
  mount_uploader :commercial_jpg, PictureUploader
  mount_uploader :commercial_webp, PictureUploader
  mount_uploader :supertall_jpg, PictureUploader
  mount_uploader :supertall_webp, PictureUploader
  mount_uploader :cultural_wide_jpg, PictureUploader
  mount_uploader :cultural_wide_webp, PictureUploader
  mount_uploader :cultural_jpg, PictureUploader
  mount_uploader :cultural_webp, PictureUploader
  mount_uploader :education_jpg, PictureUploader
  mount_uploader :education_webp, PictureUploader
  mount_uploader :office_jpg, PictureUploader
  mount_uploader :office_webp, PictureUploader
  mount_uploader :urban_design_jpg, PictureUploader
  mount_uploader :urban_design_webp, PictureUploader
  mount_uploader :medical_care_jpg, PictureUploader
  mount_uploader :medical_care_webp, PictureUploader
  mount_uploader :hospitality_jpg, PictureUploader
  mount_uploader :hospitality_webp, PictureUploader
  mount_uploader :urban_planning_jpg, PictureUploader
  mount_uploader :urban_planning_webp, PictureUploader
  mount_uploader :landscape_jpg, PictureUploader
  mount_uploader :landscape_webp, PictureUploader
  mount_uploader :interior_jpg, PictureUploader
  mount_uploader :interior_webp, PictureUploader
end
