module Admin
  class OrderRequestsController < CommonController
    require 'vk_message'

    def index
      @models = current_magazine.order_requests
    end

    def update
      items = {}
      if params[:item_id].present? && params[:count].present?
        n = -1
        params[:item_id].map {|v| items[v.to_s] = params[:count][n+=1] }
      end
      all_params = items.present? ? params_model.merge({items: items}) : params_model
      find_model.update(all_params)
      if params_model[:status] == "paid"
        find_model.paid(current_user.id, params[:cashbox_type])
        current_cashbox.calculation(params[:cashbox_type], find_model.price, true)
      end
      redirect_to_show
    end

    def reserve
      find_model.sorty_by_product.each do |id, items_hash|
        items_hash.each do |item_hash|
          item = item_hash[:product_item]
          item_count = item.product_item_counts.where(magazine_id: current_user.magazine_id).last
          item_count.update(count: (find_model.reserve ? (item_count.count + item_hash[:count]) : (item_count.count - item_hash[:count]) ) )
        end
      end
      find_model.update(reserve: !find_model.reserve)
      redirect_to "/admin/order_requests/#{find_model.id}"
    end

    private

    def model
      OrderRequest
    end

    def redirect_to_show
      redirect_to "/admin/#{model.first_url}/#{find_model.id}"
    end
  end
end