class List < ApplicationRecord
  include UUIDGenerator

  has_many :cards
  has_and_belongs_to_many :users
  belongs_to :owner, class_name: "User"

  alias_method :created_by, :owner

  validates :title, presence: { message: "Title can't be blank" }
  validates :owner, presence: { message: "List can't exist without an owner" }
end
