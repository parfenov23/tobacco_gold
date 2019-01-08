module Admin
  class ProviderItemsController < CommonController

    def index
      provider = Provider.find(params[:provider_id])
      @models = model.where(provider_id: provider.id)
      @add_title = "#{provider.title} - "
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