class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :is_active, :boolean, default: true, null: false
    add_column :users, :last_login_at, :datetime
  end
end
