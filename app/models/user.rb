class User < ApplicationRecord

  MEMBER_USER_TYPE = "member"
  USER_TYPES = {
    "member" => "Member",
    "admin" => "Admin"
  }

  validates :name, :email, :username, :user_type, presence: { message: "%{attribute} can't be blank" }
  validates :user_type, inclusion: { in: USER_TYPES.keys, message: "'%{value}' is not a valid user type" }

end
