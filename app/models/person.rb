class Person < ApplicationRecord
  has_many :city_people, dependent: :destroy
  has_many :cities, through: :city_people

  translates :name, :title, :introduce
  validates_uniqueness_of :url_name

  mount_uploader :avatar, AvatarUploader
  mount_uploader :photo, PhotoUploader

  before_create :set_new_position

  private

  def set_new_position
    self.position = Person.count
  end
end
