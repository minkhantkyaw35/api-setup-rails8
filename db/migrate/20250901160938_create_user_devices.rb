class CreateUserDevices < ActiveRecord::Migration[8.0]
  def change
    create_table :user_devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :device_name
      t.string :device_type
      t.string :device_identifier
      t.datetime :last_login_at
      t.string :ip_address
      t.text :user_agent
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end
    add_index :user_devices, :device_identifier, unique: true
  end
end
