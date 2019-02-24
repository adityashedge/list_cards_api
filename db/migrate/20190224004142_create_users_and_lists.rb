class CreateUsersAndLists < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :lists do |t|
      t.index :user_id
      t.index :list_id
    end
  end
end
