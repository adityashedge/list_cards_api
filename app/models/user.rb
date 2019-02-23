class User < ApplicationRecord
  include UUIDGenerator
  include Trackable

  attr_accessor :login

  has_secure_password validations: false

  MEMBER_USER_TYPE = "member"
  ADMIN_USER_TYPE = "admin"
  USER_TYPES = {
    "member" => "Member",
    "admin" => "Admin"
  }

  has_many :devices

  validates :name, :email, :username, :user_type, presence: { message: "%{attribute} can't be blank" }
  validates :user_type, inclusion: { in: USER_TYPES.keys, message: "'%{value}' is not a valid user type" }
  validates :password, presence: { message: "Password can't be blank" }, on: :create
  validates :password, length: { minimum: 6, too_short: "Password is too short", maximum: 20, too_long: "Password is too long" }, on: :create, if: -> { self.password.present? }
  validates :password, confirmation: { message: "Password confirmation doesn't match password" }, on: :create, if: -> { self.password_confirmation.present? }
  validates :password_confirmation, presence: { message: "Password confirmation can't be blank" }, on: :create
  validates :password, presence: { message: "Password can't be blank" }, length: { minimum: 6, too_short: "Password is too short", maximum: 20, too_long: "Password is too long" }, confirmation: { message: "Password confirmation doesn't match password" }, on: :update, if: -> { self.password.present? }
  validates :password_confirmation, presence: { message: "Password confirmation can't be blank" }, on: :update, if: -> { self.password.present? }

  validate :email_uniqueness
  def email_uniqueness
    if email.present? && email_changed?
      users = User.where("lower(email) = ?", email.downcase)
      users = users.where.not(user_id: user_id) if user_id.present?

      if users.exists?
        self.errors.add(:email, "Email has already been taken")
      end
    end
  end

  validate :username_uniqueness
  def username_uniqueness
    if username.present? && username_changed?
      users = User.where("lower(username) = ?", username.downcase)
      users = users.where.not(user_id: user_id) if user_id.present?

      if users.exists?
        self.errors.add(:username, "Username has already been taken")
      end
    end
  end

  def is_admin?
    user_type == ADMIN_USER_TYPE
  end

  def api_key(device)
    payload = { user_id: uuid, user_type: user_type }
    payload.merge!(device_id: device.uuid)
    JWT.encode(payload, JWT_SECRET)
  end
end
