class List < ApplicationRecord
  include UUIDGenerator

  has_and_belongs_to_many :users
  belongs_to :owner, class_name: "User"

  validates :owner, presence: { message: "List can't exist without an owner" }
end
