class ContactMessagesController < ApplicationController
  def new
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params)
  
    if @contact_message.save
      begin
        # Send email to business
        ContactMailer.customer_message(@contact_message).deliver_now
    
        # Send confirmation to user
        ContactMailer.confirmation_to_user(@contact_message).deliver_now
    
        Rails.logger.info "✅ Both emails sent successfully!"
      rescue => e
        Rails.logger.error "❌ Email sending failed: #{e.message}"
      end
    
      flash[:notice] = "Thank you for reaching out! A team member at Lugnuts will connect with you within 24 hours."
      redirect_to new_contact_message_path
    else
      flash.now[:alert] = "Please correct the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end
end