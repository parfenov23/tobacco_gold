module Admin
  class MixBoxItemsController < AdminController

    def index
      @models = model.where(mix_box_id: params[:mix_box_id])
    end

    def new
      @model = model.new
    end

    def create
      fm = model.create(params_model)
      redirect_to "/admin/#{model.first_url}?mix_box_id=#{fm.mix_box_id}"
    end

    def show
      @model = find_model
    end

    def edit
      @model = find_model
    end

    def update
      find_model.update(params_model)
      redirect_to "/admin/#{model.first_url}?mix_box_id=#{find_model.mix_box_id}"
    end

    def remove
      find_model.destroy
      redirect_to_index
    end

    private

    def model
      MixBoxItem
    end

    def redirect_to_index
      redirect_to :back
    end

    def find_model
      model.find(params[:id])
    end

    def params_model
      params.require(:mix_box_items).permit(model.column_names).compact.select { |k, v| v != "" } rescue {}
    end
  end
end