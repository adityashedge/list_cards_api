class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices, primary_key: :device_id do |t|
      t.string :uuid
      t.string :device_identifier
      t.string :auth_token
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.integer :sign_in_count, null: false, default: 0
      t.references :user, index: true

      t.timestamps
    end
    add_index :devices, :uuid, unique: true
    add_index :devices, :auth_token, unique: true
  end
end
