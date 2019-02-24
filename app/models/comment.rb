class Comment < ApplicationRecord
  include UUIDGenerator

  has_many :comments, as: :commentable
  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  belongs_to :card
  belongs_to :user

  validates :description, presence: { message: "Description can't be blank" }
  validates :user, :card, presence: { message: "%{attribute} can't be blank" }

  before_validation :set_card_association, on: :create
  def set_card_association
    if self.commentable_type == "Card"
      self.card = self.commentable
    else
      self.card = self.commentable.card
    end
  end
end
