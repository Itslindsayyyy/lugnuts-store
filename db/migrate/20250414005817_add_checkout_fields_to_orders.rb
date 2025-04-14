class AddCheckoutFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :fulfillment_method, :string
    add_column :orders, :ship_name, :string
    add_column :orders, :ship_street, :string
    add_column :orders, :ship_city, :string
    add_column :orders, :ship_state, :string
    add_column :orders, :ship_zip, :string
    add_column :orders, :paid, :boolean
  end
end
