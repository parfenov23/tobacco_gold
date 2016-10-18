module Admin
  class ProductPricesController < AdminController

    def index
      @product_prices = find_product.product_prices
    end

    def new
      @product_price = ProductPrice.new
    end

    def create
      ProductPrice.create(params_product_price)
      redirect_to_index
    end

    def edit
      @product_price = find_product_price
    end

    def update
      find_product_price.update_default if params_product_price[:default] == "1"
      find_product_price.update(params_product_price)
      redirect_to_index
    end

    def remove
      product_id = find_product_price.product_id
      find_product_price.destroy
      redirect_to '/admin/product_prices?product_id=' + product_id.to_s
    end

    private

    def find_product
      Product.find(params[:product_id])
    end

    def find_product_price
      ProductPrice.find(params[:id])
    end

    def redirect_to_index
      product_id = params_product_price[:product_id].present? ? params_product_price[:product_id] : find_product_price.product_id
      redirect_to '/admin/product_prices?product_id=' + product_id
    end

    def params_product_price
      params.require(:product_price).permit(:price, :product_id, :title, :default).compact rescue {}
    end
  end
end
