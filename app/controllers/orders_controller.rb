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
      fulfillment_method: "shipping"
    )
  end

  def create
    @cart = current_cart
    @order = current_user.orders.build(
      status: "Processing",
      total: @cart.cart_items.sum { |item| item.product.price * item.quantity }
    )

    if @order.save
      @cart.cart_items.each do |item|
        @order.order_items.create(
          product: item.product,
          quantity: item.quantity,
          price: item.product.price
        )
      end

      session = Stripe::Checkout::Session.create(
        payment_method_types: [ "card" ],
        line_items: @cart.cart_items.map do |item|
          {
            price_data: {
              currency: "usd",
              product_data: {
                name: item.product.name
              },
              unit_amount: (item.product.price * 100).to_i
            },
            quantity: item.quantity
          }
        end,
        mode: "payment",
        metadata: {
          order_id: @order.id
        },
        success_url: order_success_url(@order),
        cancel_url: cart_url
      )

      # Clear the cart
      @cart.cart_items.destroy_all
      session[:cart_id] = nil

      redirect_to session.url, allow_other_host: true
    else
      render :new, alert: "Something went wrong. Please try again."
    end
  end

  def success
    @order = current_user.orders.find(params[:id])
  
    unless @order.confirmation_sent_at?
      OrderMailer.confirmation(@order).deliver_later
      @order.update(confirmation_sent_at: Time.current)
    end
  
    redirect_to order_path(@order), notice: "Thanks for your purchase! Your confirmation email has been sent."
  end
  
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
