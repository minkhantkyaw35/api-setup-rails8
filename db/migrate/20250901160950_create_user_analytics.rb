class CreateUserAnalytics < ActiveRecord::Migration[8.0]
  def change
    create_table :user_analytics do |t|
      t.references :user, null: false, foreign_key: true
      t.string :event_type
      t.json :event_data
      t.string :ip_address
      t.text :user_agent
      t.datetime :occurred_at

      t.timestamps
    end
  end
end
