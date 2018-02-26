module Api
  class ProductsController < ApiController
    def index
      render json: Product.all.as_json
    end

    def show
      render json: Product.find(params[:id]).transfer_to_json
    end

    def product_items
      render json: Product.find(params[:id]).product_items.transfer_to_json
    end
  end
end