class CartItemsController < ApplicationController
  def create
    if user_signed_in?
      # Create the cart only if it doesn't exist yet
      cart = current_user.cart || current_user.create_cart
    else
      cart = Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] = cart.id
    end

    product = Product.find(params[:product_id])

    cart_item = cart.cart_items.find_by(product_id: product.id)
    if cart_item
      cart_item.quantity += 1
      cart_item.save
    else
      cart.cart_items.create(product: product, quantity: 1)
    end

    redirect_to cart_path, notice: "#{product.name} added to cart!"
  end

  def update
    item = CartItem.find(params[:id])
    if item.update(quantity: params[:cart_item][:quantity])
      redirect_to cart_path, notice: "Quantity updated"
    else
      redirect_to cart_path, alert: "Could not update quantity"
    end
  end


  def destroy
    item = CartItem.find(params[:id])
    item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end
end
