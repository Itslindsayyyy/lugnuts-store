class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token  # Stripe doesn’t send CSRF tokens

    def stripe
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      event = nil

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, ENV["STRIPE_SIGNING_SECRET"]
        )
      rescue JSON::ParserError => e
        render json: { error: "Invalid payload" }, status: 400 and return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: "Invalid signature" }, status: 400 and return
      end

      case event["type"]
      when "checkout.session.completed"
        session = event["data"]["object"]
        order_id = session["metadata"]["order_id"]
        order = Order.find_by(id: order_id)

        if order
          order.update(paid: true)
          Rails.logger.info "✅ Webhook: Marked Order ##{order.id} as paid"
        else
          Rails.logger.warn "⚠️ Webhook: No order found for ID #{order_id}"
        end
      end

      render json: { message: "Success" }, status: 200
    end
end
