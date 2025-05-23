class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_manager!, only: %i[ new create edit update destroy ]
  
  # GET /products or /products.json
  def index
    if params[:query].present?
      query = "%#{params[:query]}%"
      @products = Product
        .left_joins(:category, :tags)
        .where("products.name LIKE :q OR products.description LIKE :q OR categories.name LIKE :q OR tags.name LIKE :q", q: query)
        .distinct
    else
      @products = Product.all
    end
  end
  
  

  # GET /products/1 or /products/1.json
  def show
    @product = Product.find(params[:id])
    @category = @product.category
    @other_categories = Category.where.not(id: @category.id).sample(3)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def tagged
    @tag = Tag.find(params[:id])
    @products = @tag.products
    render :index
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :price, :description, :image_url, :sku, :wholesale_cost, :stock_quantity, :category_id, tag_ids: [])
    end
end
