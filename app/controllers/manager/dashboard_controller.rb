class Manager::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_manager

  def index
    # Manager-specific dashboard data here
  end

  private

  def authorize_manager
    unless current_user&.manager? || current_user&.admin?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
