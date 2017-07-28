module Admin
  class MixBoxesController < AdminController

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
      find_model.update(params_model)
      redirect_to_index
    end

    def remove
      find_model.destroy
      redirect_to_index
    end

    private

    def model
      MixBox
    end

    def redirect_to_index
      redirect_to "/admin/#{model.first_url}"
    end

    def find_model
      model.find(params[:id])
    end

    def params_model
      params.require(:mix_boxes).permit(model.column_names).compact.select { |k, v| v != "" } rescue {}
    end
  end
end