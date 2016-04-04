class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    Product.create(params_product)
    redirect_to_index
  end

  def edit
    @product = find_product
  end

  def update
    find_product.update(params_product)
    redirect_to_index
  end

  def remove
    find_product.destroy
    redirect_to_index
  end

  private

  def find_product
    Product.find(params[:id])
  end

  def redirect_to_index
    redirect_to '/products'
  end

  def params_product
    params.require(:product).permit(:title).compact rescue {}
  end
end
