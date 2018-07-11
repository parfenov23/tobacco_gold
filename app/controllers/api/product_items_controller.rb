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

    def search
      search_items = ProductItem.search_title_or_barcode(current_company.id, params[:search])
      search_items = search_items.all_present(current_magazine.id) if params[:type] == "present"
      render json: search_items.transfer_to_json
    end

    def get_search
      product_item = ProductItem.where(barcode: params[:barcode], product_id: Product.where(company_id: current_company.id).ids).last
      render text: "<p>" + (product_item.present? ? product_item.get_description : "Нет описания") + "<p>"
    end

    def get_img_url

    end
  end
end