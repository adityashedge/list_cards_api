class Device < ApplicationRecord
  include UUIDGenerator
  include Trackable
  include Tokenable

  belongs_to :user

  validates :device_identifier, presence: { message: "Device identifier can't be blank" }, uniqueness: { scope: :user_id, message: "Device already registered for this user" }
end
