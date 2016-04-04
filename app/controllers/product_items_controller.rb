class ProductItemsController < ApplicationController

  def index
    @product_items = find_product.product_items
  end

  def new
    @product_item = ProductItem.new
  end

  def create
    ProductItem.create(params_product_item)
    redirect_to_index
  end

  def edit
    @product_item = find_product_item
  end

  def update
    find_product_item.update(params_product_item)
    redirect_to_index
  end

  def remove
    find_product_item.destroy
    redirect_to_index
  end

  private

  def find_product
    Product.find(params[:product_id])
  end

  def find_product_item
    ProductItem.find(params[:id])
  end

  def redirect_to_index
    product_id = params_product_item[:product_id].present? ? params_product_item[:product_id] : find_product_item.product_id
    redirect_to '/product_items?product_id=' + product_id
  end

  def params_product_item
    params.require(:product_item).permit(:title, :product_id, :count).compact rescue {}
  end
end
