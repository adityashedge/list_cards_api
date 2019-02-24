class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments, primary_key: :comment_id do |t|
      t.uuid :uuid
      t.text :description
      t.integer :comments_count, null: false, default: 0
      t.references :commentable, polymorphic: true, index: true
      t.references :user, index: true

      t.timestamps
    end
    add_index :comments, :uuid, unique: true
    add_index :comments, :comments_count
  end
end
