# frozen_string_literal: true

class User < ApplicationRecord

  enum user_type: { PASSENGER: 'passenger', DRIVER: 'driver' }

  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :user_type, inclusion: { in: User.user_types.keys }
  validates :email, :password_digest, :user_type, presence: true
end
