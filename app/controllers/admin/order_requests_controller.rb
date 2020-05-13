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
      model_paid(params[:cashbox_type]) if params_model[:status] == "paid"
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

    def update_new_price
      product_item = ProductItem.find(params[:item_id])
      product = product_item.product
      curr_price = product.product_prices.find_or_create_by(price: params[:new_price], title: params[:new_price].to_s)
      all_items_hash = find_model.items
      curr_item = eval(all_items_hash[params[:item_id].to_s])
      curr_count = (curr_item[:count] rescue curr_item).to_i
      all_items_hash[params[:item_id].to_s] = {count: curr_count, price_id: curr_price.id}
      find_model.update(items: all_items_hash)
      render json: {success: true}
    end

    def next_status
      next_status = OrderRequest.next_status(find_model.status)
      model_paid(find_model.type_payment) if next_status == "paid"
      find_model.update(status: next_status)
      redirect_to :back
    end

    def update_all_status
      all_order_requests = current_magazine.order_requests.where(status: params[:status])
      next_status = OrderRequest.next_status(params[:status])
      if next_status == "paid"
        all_order_requests.each do |order_request|
          cashbox_type = order_request.type_payment
          order_request.paid(current_user.id, cashbox_type)
          current_cashbox.calculation(cashbox_type, order_request.price, true)
        end
      end
      all_order_requests.update_all(status: next_status)
      redirect_to :back
    end

    private

    def model
      OrderRequest
    end

    def model_paid(cashbox_type="cash")
      find_model.paid(current_user.id, cashbox_type)
      current_cashbox.calculation(cashbox_type, find_model.price, true)
    end

    def redirect_to_show
      redirect_to "/admin/#{model.first_url}/#{find_model.id}"
    end
  end
end