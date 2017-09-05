module Admin
  class ProviderItemsController < AdminController

    def index
      @models = model.where(provider_id: params[:provider_id])
    end

    def new
      @model = model.new
    end

    def create
      fm = model.create(params_model)
      redirect_to "/admin/#{model.first_url}?provider_id=#{fm.provider_id}"
    end

    def show
      @model = find_model
    end

    def edit
      @model = find_model
    end

    def update
      find_model.update(params_model)
      redirect_to "/admin/#{model.first_url}?provider_id=#{find_model.provider_id}"
    end

    def remove
      find_model.destroy
      redirect_to_index
    end

    private

    def model
      ProviderItem
    end

    def redirect_to_index
      redirect_to :back
    end

    def find_model
      model.find(params[:id])
    end

    def params_model
      params.require(:provider_items).permit(model.column_names).compact.select { |k, v| v != "" } rescue {}
    end
  end
end