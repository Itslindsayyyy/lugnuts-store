class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products
    render 'products/index'  # reuse the existing index view
  end

  def index
    @categories = Category.all
    @products = Product.page(params[:page]).per(20)
  end
end


