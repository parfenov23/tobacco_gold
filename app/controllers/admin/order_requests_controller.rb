module Admin
  class OrderRequestsController < CommonController
    require 'vk_message'

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

    private

    def model
      OrderRequest
    end

    def redirect_to_show
      redirect_to "/admin/#{model.first_url}/#{find_model.id}"
    end
  end
end