class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = current_cart
  
    @order = Order.new(
      email: current_user.email,
      phone: current_user.phone,
      ship_name: current_user.first_name,
      ship_street: current_user.street,
      ship_city: current_user.city,
      ship_state: current_user.state,
      ship_zip: current_user.zip,
      fulfillment_method: 'shipping'
    )
  end

  def create
    @cart = current_cart
    @order = current_user.orders.build(
      status: "Processing",
      total: @cart.cart_items.sum { |item| item.product.price * item.quantity }
    )
  
    if @order.save
      # Create order items from cart items
      @cart.cart_items.each do |item|
        @order.order_items.create(
          product: item.product,
          quantity: item.quantity,
          price: item.product.price
        )
      end
  
      # 🔄 Build Stripe line items
      line_items = @order.order_items.map do |item|
        {
          price_data: {
            currency: 'usd',
            product_data: {
              name: item.product.name
            },
            unit_amount: (item.price * 100).to_i  # <== Right here!
          },
          quantity: item.quantity
        }
      end
  
      # 🔐 Create Stripe Checkout session
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: line_items,
        mode: 'payment',
        success_url: order_success_url(@order),
        cancel_url: cart_url
      )
  
      # ✅ Clear cart only after payment success (optional)
      # @cart.cart_items.destroy_all — move this to success action
  
      redirect_to session.url, allow_other_host: true
    else
      render :new, alert: "Something went wrong. Please try again."
    end

    metadata: {
     order_id: @order.id
    }
  end

  # Order history
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
