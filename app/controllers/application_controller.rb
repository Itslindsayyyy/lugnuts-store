class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :admin?, :manager?, :current_cart

  def current_cart
    if user_signed_in?
      current_user.cart
    else
      @guest_cart ||= Cart.find_by(id: session[:cart_id])
    end
  end

  def admin?
    current_user&.admin?
  end

  def manager?
    current_user&.manager? || current_user&.admin?
  end

  def authenticate_admin!
    redirect_to root_path, alert: "Not authorized" unless admin?
  end

  def authenticate_manager!
    redirect_to root_path, alert: "Not authorized" unless manager?
  end

  # Add Devise permitted parameters
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_out_path_for(_resource_or_scope)
    flash[:notice] = "You’ve been logged out successfully."
    root_path
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:first_name, :last_name, :email, :phone, :street, :city, :state, :zip, :password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
