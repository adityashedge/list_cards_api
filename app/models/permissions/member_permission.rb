module Permissions
  class MemberPermission < BasePermission
    def set_permissions
      allow "v1/lists", [:index]
      allow "v1/lists", [:show] do |list|
        user.lists.exists?(list.list_id)
      end

      allow "v1/cards", [:index, :create]
      allow "v1/cards", [:show, :update, :destroy] do |card|
        card.user_id == user.user_id
      end

      allow "v1/comments", [:index, :create, :show, :destroy] do |commentable|
        Card.where(cards: { list_id: user.list_ids, card_id: commentable.card_id }).exists?
      end
      allow "v1/comments", [:update] do |comment|
        comment.user_id == user.user_id
      end
    end
  end
end
