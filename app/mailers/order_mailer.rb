class OrderMailer < ApplicationMailer
    def confirmation(order)
      @order = order
      @user = order.user
      @order_items = order.order_items.includes(:product)
  
      mail(
        to: @user.email,
        subject: "Your Lugnuts order ##{order.id} confirmation"
      )
    end
  end
  