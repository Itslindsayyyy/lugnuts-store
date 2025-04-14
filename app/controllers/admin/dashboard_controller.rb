# app/controllers/admin/dashboard_controller.rb
module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def index
      # You can assign things for the view here, like:
      # @users = User.all
    end

    private

    def require_admin
      redirect_to root_path, alert: "Access denied." unless current_user&.admin?
    end
  end
end
