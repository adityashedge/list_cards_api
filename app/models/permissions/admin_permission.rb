module Permissions
  class AdminPermission < BasePermission
    def set_permissions
      allow "v1/users", [:index]
      allow "v1/lists", [:index, :create, :show]
      allow "v1/lists", [:update, :destroy, :assign_member, :unassign_member] do |list|
        list.owner_id == user.user_id
      end

      allow "v1/cards", [:index, :create, :show]
      allow "v1/cards", [:update] do |card|
        card.user_id == user.user_id
      end
      allow "v1/cards", [:destroy] do |card|
        card.user_id == user.user_id || card.list.owner_id == user.user_id
      end

      allow "v1/comments", [:index, :create, :show, :destroy]
      allow "v1/comments", [:update] do |comment|
        comment.user_id == user.user_id
      end
    end
  end
end
