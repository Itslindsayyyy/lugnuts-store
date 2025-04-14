class WishlistItemsController < ApplicationController
    before_action :authenticate_user!

    def index
      @wishlist_products = current_user.wishlist_products
    end

    def create
      product = Product.find(params[:product_id])
      current_user.wishlist_products << product unless current_user.wishlist_products.include?(product)
      redirect_back fallback_location: products_path, notice: "Added to your wishlist!"
    end

    def destroy
      product = Product.find(params[:id])
      current_user.wishlist_products.destroy(product)
      redirect_back fallback_location: products_path, notice: "Removed from your wishlist."
    end
end
