require 'active_support/concern'

module UUIDGenerator
  extend ActiveSupport::Concern

  included do
    before_create do
      self.uuid = self.generate_uuid
    end
  end

  def generate_uuid
    loop do
      uuid = SecureRandom.uuid
      break uuid unless self.class.where(uuid: uuid).exists?
    end
  end
end
