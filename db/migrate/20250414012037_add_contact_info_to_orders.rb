class AddContactInfoToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :email, :string
    add_column :orders, :phone, :string
  end
end
