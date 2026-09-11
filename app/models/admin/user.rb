# frozen_string_literal: true

class Admin::User < ApplicationRecord
  self.table_name = "users"

  has_secure_password
  before_validation { self.email = email.to_s.strip.downcase }
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
    uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}, if: -> { new_record? || password.present? }
end
