class Users::RegistrationsController < Devise::RegistrationsController
    protected
  
    # Skip requiring current password when updating user info (unless password is being changed)
    def update_resource(resource, params)
      if params[:password].present?
        super
      else
        resource.update_without_password(params.except(:current_password))
      end
    end
  end
  