module Admin
  class MixBoxItemsController < CommonController

    def index
      @models = model.where(mix_box_id: params[:mix_box_id])
    end

    def create
      fm = model.create(params_model)
      redirect_to "/admin/#{model.first_url}?mix_box_id=#{fm.mix_box_id}"
    end

    def update
      find_model.update(params_model)
      redirect_to "/admin/#{model.first_url}?mix_box_id=#{find_model.mix_box_id}"
    end

    private

    def model
      MixBoxItem
    end

    def redirect_to_index
      redirect_to :back
    end
  end
end