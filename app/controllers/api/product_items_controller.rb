module Api
  class ProductItemsController < ApiController
    def index
      all_product_items = ProductItem.all_company(current_company)
      product_items = if params[:type] == "all"
        all_product_items
      elsif params[:type] == "present"
        all_product_items.all_present(current_magazine)
      elsif params[:type] == "top"
        all_product_items.where(top: true)
      elsif params[:type] == "where"
        all_product_items.all_present(current_magazine).where(JSON.parse(params[:where]))
      end
      render json: product_items.transfer_to_json(params[:api_key])
    end

    def show
      render json: ProductItem.find(params[:id]).transfer_to_json(params[:api_key])
    end

    def get_search
      product_items = current_company.products.product_items.where(barcode: params[:barcode])
      product_items = product_items.all_present(current_magazine.id) if params[:type] == "present"
      render json: {ids: product_items.ids}
    end

    def load
      arr_params_items = params[:load]
      arr_params_items = arr_params_items.each_slice(1000)
      Thread.new do
        agent = Mechanize.new
        arr_params_items.each do |arr_items|
          page = agent.post("https://crm-stock.ru/api/product_items/load_limit", {api_key: params[:api_key], load: arr_items}.to_json, {"Content-Type" => "application/json"})
        end
      end
      render json: {success: params.as_json}
    end

    def load_limit
      arr_product_items = params[:load]
      arr_product_items.each do |json_product_item|        
        category = Category.find_or_create_by(company_id: current_company.id, first_name: json_product_item["category"])
        product = Product.find_or_create_by(company_id: current_company.id, title: json_product_item["product"], category_id: category.id)

        product_item = ProductItem.find_or_create_by(uid: json_product_item["uid"], product_id: product.id)
        product_item.title = product_item.title.blank? ? json_product_item["title"] : product_item.title
        product_item.barcode = json_product_item["barcode"] if json_product_item["barcode"].present?

        arr_tags = json_product_item["tag"].split(",")
        product_item.tags = arr_tags.map do |tag| 
          Tag.find_or_create_by(company_id: current_company.id, title: tag)
        end
        product_item.save

        price = product.product_prices.find_or_create_by(price: json_product_item["price"], title: json_product_item["price"])
        product_item.price_id(nil, {magazine_id: current_magazine.id, price_id: price.id})

        product_item.product_item_counts.find_or_create_by(magazine_id: current_magazine.id).update(count: json_product_item["count"])
      end
    end

    def search
      render json: current_company.products.product_items.full_text_search(params[:search]).all_present(current_magazine.id).transfer_to_json(current_magazine.api_key)
    end

    def get_img_url

    end
  end
end