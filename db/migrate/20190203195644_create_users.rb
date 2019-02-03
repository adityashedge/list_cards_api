class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, primary_key: :user_id do |t|
      t.uuid :uuid
      t.string :name
      t.string :user_type, default: User::MEMBER_USER_TYPE
      t.string :email
      t.string :username
      t.string :password_digest
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.integer :sign_in_count, null: false, default: 0

      t.timestamps
    end

    add_index :users, :uuid, unique: true
    add_index :users, :user_type
    add_index :users, :email, unique: true
    add_index :users, "lower(email)", name: "index_users_on_lower_email_unique", unique: true
    add_index :users, :username, unique: true
    add_index :users, "lower(username)", name: "index_users_on_lower_username_unique", unique: true
  end
end
