class AddAddressFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :string
  end
end
