module Admin
  class ProviderItemsController < CommonController

    def index
      @models = model.where(provider_id: params[:provider_id])
    end

    def create
      fm = model.create(params_model)
      redirect_to "/admin/#{model.first_url}?provider_id=#{fm.provider_id}"
    end

    def update
      find_model.update(params_model)
      render_json_success(find_model)
    end

    private

    def model
      ProviderItem
    end

    def redirect_to_index
      redirect_to :back
    end

  end
end