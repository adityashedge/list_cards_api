class Device < ApplicationRecord
  include UUIDGenerator
  include Trackable

  belongs_to :user
end
