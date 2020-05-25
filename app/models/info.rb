class Info < ApplicationRecord
  mount_uploader :picture, PictureUploader
  mount_uploader :banner, BannerUploader
  mount_uploader :snapshot, SnapshotUploader

  has_many :pictures

  validates :title, presence: true
  validates :introduction, presence: true
  validates :content, presence: true

  before_create :set_new_position

  private

  def set_new_position
    self.position = Info.count
  end
end
