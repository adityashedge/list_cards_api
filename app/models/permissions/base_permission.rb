module Permissions
  class BasePermission
    attr_reader :user
    attr_reader :allowed_actions

    def initialize(user)
      @allowed_actions = {}
      @user = user

      set_permissions
    end

    def set_permissions
    end

    def allow?(controller, action, resource = nil)
      allowed = @allowed_actions[[controller.to_s, action.to_s]]
      allowed && (allowed == true || resource && allowed.call(resource))
    end

    def allow(controllers, actions, &block)
      @allowed_actions ||= {}
      Array(controllers).each do |controller|
        Array(actions).each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end
  end
end
