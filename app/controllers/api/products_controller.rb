module Api
  class ProductsController < ApiController
    require 'vk_message'
    def index
      render json: Product.all.as_json
    end

    def show
      render json: Product.find(params[:id]).transfer_to_json
    end

    def prices
      VkMessage.message_price(params)
      render text: params[:return]
    end

    def product_items
      render json: Product.find(params[:id]).product_items.all_present(current_magazine).transfer_to_json
    end
  end
end