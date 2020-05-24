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

    def search
      search_items = ProductItem.search_title_or_barcode(current_company.id, params[:search])
      search_items = search_items.all_present(current_magazine.id) if params[:type] == "present"
      render json: search_items.transfer_to_json
    end

    def get_search
      product_item = ProductItem.where(barcode: params[:barcode], product_id: Product.where(company_id: current_company.id).ids).last
      render text: "<p>" + (product_item.present? ? product_item.get_description : "Нет описания") + "<p>"
    end

    def load
      arr_product_items = params[:load]
      arr_product_items.each do |json_product_item|
        find_product_item = ProductItem.where(uid: json_product_item["uid"]).last
        product_item = find_product_item.present? ? find_product_item : ProductItem.new(uid: json_product_item["uid"])
        product_item.title = json_product_item["title"]
        product_item.barcode = json_product_item["barcode"]
        
        find_category = Category.where(company_id: current_company.id, first_name: json_product_item["category"]).last
        category = find_category.present? ? find_category : Category.new(company_id: current_company.id)
        category.first_name = json_product_item["category"]
        
        find_product = Product.where(company_id: current_company.id, title: json_product_item["product"]).last
        product = find_product.present? ? find_product : Product.new(company_id: current_company.id)
        product.title = json_product_item["product"]

        product.category = category
        product_item.product = product

        arr_tags = json_product_item["tag"].split(",")
        product_item.tags = arr_tags.map do |tag| 
          find_tag = Tag.where(company_id: current_company.id, title: tag).last
          find_tag.present? ? find_tag : Tag.create(company_id: current_company.id, title: tag)
        end

        category.save
        product.save
        product_item.save

        find_price = product.product_prices.where(price: json_product_item["price"]).last
        price = find_price.present? ? find_price : product.product_prices.create(price: json_product_item["price"], title: json_product_item["price"])
        product_item.price_id(nil, {magazine_id: current_magazine.id, price_id: price.id})


        find_count = product_item.product_item_counts.where(magazine_id: current_magazine.id).last
        current_count = find_count.present? ? find_count : product_item.product_item_counts.create(magazine_id: current_magazine.id)
        current_count.count = json_product_item["count"]
        current_count.save

      end
      render json: {success: params.as_json}
    end

    def search
      render json: current_company.products.product_items.full_text_search(params[:search]).transfer_to_json
    end

    def get_img_url

    end
  end
end