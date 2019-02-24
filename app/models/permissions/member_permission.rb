module Permissions
  class MemberPermission < BasePermission
    def set_permissions
      allow "v1/lists", [:index]
      allow "v1/lists", [:show] do |list|
        user.lists.exists?(list.list_id)
      end
    end
  end
end
