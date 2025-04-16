class Admin::ProductsController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_manager!
  
    def update_stock
      @product = Product.find(params[:id])
  
      if @product.update(stock_quantity: params[:stock_quantity])
        redirect_to admin_inventory_path, notice: "Stock updated for #{@product.name}."
      else
        redirect_to admin_inventory_path, alert: "Failed to update stock."
      end
    end
  end
  