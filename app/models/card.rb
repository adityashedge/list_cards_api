class Card < ApplicationRecord
  include UUIDGenerator

  has_many :comments, as: :commentable
  belongs_to :list
  belongs_to :owner, class_name: "User"

  alias_method :created_by, :owner

  validates :title, :description, presence: { message: "%{attribute} can't be blank" }
  validates :owner, presence: { message: "List can't exist without an owner" }
  validates :list, presence: { message: "Card can't exist without a list" }
end
