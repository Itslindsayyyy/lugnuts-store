class CategoriesController < ApplicationController
  def show
    @category = Category.find_by(id: params[:id])
    if @category
      @products = @category.products.includes(:tags).order(:name).page(params[:page]).per(20)
    else
      redirect_to categories_path, alert: "Category not found"
    end
  end

  def index
    @categories = Category.all
    @tags = Tag.all
  
    @products = Product.includes(:category, :tags).order(:name)
  
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
  
    if params[:tag_id].present?
      @products = @products.joins(:tags).where(tags: { id: params[:tag_id] })
    end
  
    @products = @products.page(params[:page]).per(20)
  end
  
end
