module Admin
  class ProductPricesController < CommonController

    def index
      @product_prices = find_product.product_prices.where(archive: false)
    end

    def update
      find_model.update_default if params_model[:default] == "1"
      find_model.update(params_model)
      redirect_to_index
    end

    def remove
      product_id = find_model.product_id
      find_model.update(archive: true)
      redirect_to '/admin/product_prices?product_id=' + product_id.to_s
    end

    private

    def model 
      ProductPrice
    end

    def find_product
      Product.find(params[:product_id])
    end

    def redirect_to_index
      product_id = params_model[:product_id].present? ? params_model[:product_id] : find_model.product_id
      redirect_to '/admin/product_prices?product_id=' + product_id
    end

  end
end
