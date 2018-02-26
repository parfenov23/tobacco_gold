module Api
  class ProductItemsController < ApiController
    def index
      product_items = if params[:type] == "all"
        ProductItem.all 
      elsif params[:type] == "present"
        ProductItem.all_present(Magazine.ids)
      elsif params[:type] == "top"
        ProductItem.where(top: true)
      elsif params[:type] == "where"
        ProductItem.where(JSON.parse(params[:where]))
      end
      render json: product_items.transfer_to_json
    end

    def show
      render json: ProductItem.find(params[:id]).transfer_to_json
    end
  end
end