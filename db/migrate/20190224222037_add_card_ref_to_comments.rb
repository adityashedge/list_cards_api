class AddCardRefToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :card, index: true
  end
end
