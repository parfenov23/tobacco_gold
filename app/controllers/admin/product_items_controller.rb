module Admin
  class ProductItemsController < CommonController

    def index
      @product_items = find_product.product_items
    end

    def remove
      product_id = find_model.product_id
      find_model.destroy
      redirect_to '/admin/product_items?product_id=' + product_id.to_s
    end

    private

    def model
      ProductItem
    end

    def find_product
      Product.find(params[:product_id])
    end

    def redirect_to_index
      product_id = params_model[:product_id].present? ? params_model[:product_id] : find_model.product_id
      redirect_to '/admin/product_items?product_id=' + product_id
    end
  end
end