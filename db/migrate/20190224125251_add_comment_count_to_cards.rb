class AddCommentCountToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :comments_count, :integer, null: false, default: 0
    add_index :cards, :comments_count
  end
end
