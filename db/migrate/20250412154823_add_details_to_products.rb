class AddDetailsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :sku, :string
    add_column :products, :wholesale_cost, :decimal
    add_column :products, :stock_quantity, :integer
    add_column :products, :tags, :string
  end
end
