class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_admin, :boolean
    add_column :users, :organization_name, :string
    add_column :users, :name, :string
    add_column :users, :phone_number, :integer
  end
end
