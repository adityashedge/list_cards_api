class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards, primary_key: :card_id do |t|
      t.uuid :uuid
      t.string :title
      t.text :description
      t.references :owner, index: true
      t.references :list, index: true

      t.timestamps
    end
    add_index :cards, :uuid, unique: true
  end
end
