class RenameOwnerIdToUserIdInCards < ActiveRecord::Migration[5.2]
  def change
    rename_index  :cards, 'index_cards_on_owner_id', 'index_cards_on_user_id'
    rename_column :cards, :owner_id, :user_id
  end
end
