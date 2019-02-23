module Permissions
  class AdminPermission < BasePermission
    def set_permissions
      allow "v1/users", [:index]
    end
  end
end
