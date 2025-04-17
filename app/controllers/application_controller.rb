class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :admin?, :manager?, :current_cart

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :merge_guest_cart, if: :user_signed_in?

  def current_cart
    if user_signed_in?
      current_user.cart || create_user_cart
    else
      find_or_create_guest_cart
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

  def after_sign_out_path_for(_resource_or_scope)
    flash[:notice] = "You’ve been logged out successfully."
    root_path
  end

  protected

  def configure_permitted_parameters
    added_attrs = [ :first_name, :last_name, :email, :phone, :street, :city, :state, :zip, :password, :password_confirmation, :current_password ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

  def create_user_cart
    cart = Cart.create(user: current_user)
    current_user.update(cart: cart)
    cart
  end

  def find_or_create_guest_cart
    if session[:cart_id]
      Cart.find_by(id: session[:cart_id]) || create_guest_cart
    else
      create_guest_cart
    end
  end

  def create_guest_cart
    cart = Cart.create # No user assigned
    session[:cart_id] = cart.id
    cart
  end

  def merge_guest_cart
    return unless session[:cart_id]

    guest_cart = Cart.find_by(id: session[:cart_id])
    return unless guest_cart

    user_cart = current_user.cart || create_user_cart

    guest_cart.cart_items.each do |item|
      existing_item = user_cart.cart_items.find_by(product_id: item.product_id)

      if existing_item
        existing_item.update(quantity: existing_item.quantity + item.quantity)
      else
        user_cart.cart_items.create(product: item.product, quantity: item.quantity)
      end
    end

    guest_cart.destroy
    session[:cart_id] = nil
  end
end
