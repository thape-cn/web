# frozen_string_literal: true

class TailHome < ApplicationRecord
  has_one :hero_news, class_name: "Info", foreign_key: :id, primary_key: :hero_news_id
  has_one :work_1, class_name: "Work", foreign_key: :id, primary_key: :new_project_1_id
  has_one :work_2, class_name: "Work", foreign_key: :id, primary_key: :new_project_2_id
  has_one :work_3, class_name: "Work", foreign_key: :id, primary_key: :new_project_3_id
  has_one :work_4, class_name: "Work", foreign_key: :id, primary_key: :new_project_4_id
  has_one :work_5, class_name: "Work", foreign_key: :id, primary_key: :new_project_5_id
  has_one :work_6, class_name: "Work", foreign_key: :id, primary_key: :new_project_6_id

  has_one :news_1, class_name: "Info", foreign_key: :id, primary_key: :info_1_id
  has_one :news_2, class_name: "Info", foreign_key: :id, primary_key: :info_2_id
  has_one :news_3, class_name: "Info", foreign_key: :id, primary_key: :info_3_id

  MIN_WALLPAPERS = 3
  MAX_WALLPAPERS = 10

  has_many :wallpapers, -> { order(:position, :id) }, class_name: "TailHomeWallpaper", inverse_of: :tail_home, dependent: :destroy
  accepts_nested_attributes_for :wallpapers, allow_destroy: true
  before_validation :normalize_wallpaper_positions
  validate :wallpaper_count_within_limits

  mount_uploader :new_project_photo_1, PictureUploader
  mount_uploader :new_project_photo_2l, PictureUploader
  mount_uploader :new_project_photo_3w, PictureUploader
  mount_uploader :new_project_photo_4, PictureUploader
  mount_uploader :new_project_photo_5, PictureUploader
  mount_uploader :new_project_photo_6, PictureUploader

  mount_uploader :info_1_photo, PictureUploader
  mount_uploader :info_2_photo, PictureUploader
  mount_uploader :info_3_photo, PictureUploader

  mount_uploader :hero_news_photo, PictureUploader
  mount_uploader :hero_news_photo_mobile, PictureUploader

  private

  def normalize_wallpaper_positions
    wallpapers.reject(&:marked_for_destruction?).sort_by { |wallpaper| wallpaper.position.to_i }.each_with_index do |wallpaper, index|
      wallpaper.position = index + 1
    end
  end

  def wallpaper_count_within_limits
    count = wallpapers.count { |wallpaper| !wallpaper.marked_for_destruction? }
    return if (MIN_WALLPAPERS..MAX_WALLPAPERS).cover?(count)

    errors.add(:base, I18n.t("admin.home_wallpaper.count_error", min: MIN_WALLPAPERS, max: MAX_WALLPAPERS))
  end
end
