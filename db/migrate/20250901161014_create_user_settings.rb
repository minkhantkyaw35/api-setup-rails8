class CreateUserSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :user_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :device_limit, default: 5, null: false

      t.timestamps
    end
  end
end
