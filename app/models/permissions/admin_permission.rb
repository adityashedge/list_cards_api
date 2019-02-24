module Permissions
  class AdminPermission < BasePermission
    def set_permissions
      allow "v1/users", [:index]
      allow "v1/lists", [:index, :create, :show]
      allow "v1/lists", [:update, :destroy, :assign_member, :unassign_member] do |list|
        list.owner_id == user.user_id
      end
    end
  end
end
