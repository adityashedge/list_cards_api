class Comment < ApplicationRecord
  include UUIDGenerator

  has_many :comments, as: :commentable
  belongs_to :commentable, polymorphic: true, counter_cache: :comments_count
  belongs_to :user
end
