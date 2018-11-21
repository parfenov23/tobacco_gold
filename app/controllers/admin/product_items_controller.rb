module Admin
  class ProductItemsController < CommonController

    def index
      @product_items = find_product.product_items
    end

    def remove
      product_id = find_model.product_id
       find_model.update(archive: true)
      redirect_to '/admin/product_items?product_id=' + product_id.to_s
    end

    def update
      product_item = find_model
      product_item.update(params_model.merge({price_id: params[:product_items][:price_id]}))
      if params[:product_items][:count].present?
        product_item.product_item_counts.find_by_magazine_id(magazine_id).update(count: params[:product_items][:count])
      end
       params[:typeAction] == "json" ? render_json_success(find_model) : redirect_to_index
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