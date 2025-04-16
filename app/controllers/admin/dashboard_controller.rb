# app/controllers/admin/dashboard_controller.rb
module Admin
  class DashboardController < ApplicationController
    before_action :require_manager_or_admin

    def index
      # You can assign things for the view here, like:
      # @users = User.all
    end

    def inventory
      @categories = Category.all
      @tags = Tag.all
    
      @products = Product.includes(:category, :tags).order(:name)
    
      # Filter by category
      if params[:category_id].present?
        @products = @products.where(category_id: params[:category_id])
      end
    
      # Filter by tag
      if params[:tag_id].present?
        @products = @products.joins(:tags).where(tags: { id: params[:tag_id] })
      end
    
      @products = @products.page(params[:page]).per(50)
    end
    

    private

    def require_manager_or_admin
      redirect_to root_path, alert: "Access denied." unless manager?
    end
  end
end
