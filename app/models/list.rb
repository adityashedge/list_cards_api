class List < ApplicationRecord
  include UUIDGenerator

  belongs_to :owner, class_name: "User"

  validates :owner, presence: { message: "List can't exist without an owner" }
end
