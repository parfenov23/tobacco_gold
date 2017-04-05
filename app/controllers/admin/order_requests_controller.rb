module Admin
  class OrderRequestsController < AdminController
    require 'vk_message'

    def index
      @models = model.all
    end

    def new
      @model = model.new
    end

    def create
      model.create(params_model)
      redirect_to_index
    end

    def show
      @model = find_model
    end

    def edit
      @model = find_model
    end

    def update
      items = {}
      if params[:item_id].present? && params[:count].present?
        n = -1
        params[:item_id].map {|v| items[v.to_s] = params[:count][n+=1] }
      end
      all_params = items.present? ? params_model.merge({items: items}) : params_model
      find_model.update(all_params)
      find_model.paid if params_model[:status] == "paid"
      redirect_to_show
    end

    def remove
      find_model.destroy
      redirect_to_index
    end

    private

    def model
      OrderRequest
    end

    def redirect_to_index
      redirect_to "/admin/#{model.first_url}"
    end

    def redirect_to_show
      redirect_to "/admin/#{model.first_url}/#{find_model.id}"
    end

    def find_model
      model.find(params[:id])
    end

    def params_model
      params.require(model.to_s.downcase.to_sym).permit(model.column_names).compact.select { |k, v| v != "" } rescue {}
    end
  end
end