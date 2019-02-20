class Device < ApplicationRecord
  include UUIDGenerator
  include Trackable
  include Tokenable

  belongs_to :user
end
