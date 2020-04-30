module Api
  class ProductsController < ApiController
    require 'vk_message'
    def index
      render json: current_company.products.current_presents_items.as_json
    end

    def show
      render json: Product.find(params[:id]).transfer_to_json
    end

    def prices
      VkMessage.message_price(params)
      render text: params[:return]
    end

    def find_tags
      render json: all_tags.as_json
    end

    def tag_product_items
      render json: all_tags.where(id: params[:tag_id]).last.product_items.transfer_to_json(params[:api_key])
    end

    def product_items
      render json: Product.find(params[:id]).product_items.all_present(current_magazine).transfer_to_json(params[:api_key])
    end

    private

    def all_tags
      Tag.joins(:product_items).where(["product_items.product_id = ?", params[:id]]).uniq
    end
  end
end