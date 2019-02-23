class AddUniqueIndexForDeviceIdentifierToDevices < ActiveRecord::Migration[5.2]
  def change
    add_index :devices, :device_identifier
    add_index :devices, [:user_id, :device_identifier], unique: true
  end
end
