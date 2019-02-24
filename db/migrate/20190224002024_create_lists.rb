class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists, primary_key: :list_id do |t|
      t.uuid :uuid
      t.string :title
      t.references :owner, index: true

      t.timestamps
    end
  end
end
