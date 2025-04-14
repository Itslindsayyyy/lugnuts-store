class ContactMailer < ApplicationMailer
    default to: 'itslindsaycoding@gmail.com' # support@lugnutsauto.com
  
    def customer_message(contact_message)
      @contact_message = contact_message
      mail(
        subject: "New Contact Message from #{@contact_message.name}",
        from: @contact_message.email
      )
    end
  
    def confirmation_to_user(contact_message)
      @contact_message = contact_message
      mail(
        to: @contact_message.email,
        subject: "Thanks for contacting Lugnuts Automotive!",
        from: 'itslindsaycoding@gmail.com' # Make sure this is authorized in SendGrid
      )
    end
  end