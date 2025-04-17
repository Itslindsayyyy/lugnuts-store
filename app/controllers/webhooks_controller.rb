# app/controllers/webhooks_controller.rb
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    event = nil

    begin
      endpoint_secret = ENV["STRIPE_WEBHOOK_SECRET"]
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      render json: { error: "Invalid payload" }, status: 400 and return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: "Invalid signature" }, status: 400 and return
    end

    case event.type
    when "checkout.session.completed"
      session = event.data.object
      handle_successful_checkout(session)
    end

    render json: { message: "success" }
  end

  private

  def handle_successful_checkout(session)
    order_id = session.metadata.order_id
    order = Order.find_by(id: order_id)

    return unless order.present? && order.confirmation_sent_at.nil?

    # Send confirmation email and mark sent
    OrderMailer.confirmation(order).deliver_later
    order.update(confirmation_sent_at: Time.current)
  end
end
