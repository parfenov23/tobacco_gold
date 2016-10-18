module Admin
  class OtherBuyController < AdminController

    def index
      @other_buys = model.all.order("created_at DESC")
    end

    def new
      @other_buy = model.new
    end

    def create
      other_buy = OtherBuy.create(params_model)
      other_buy.notify_buy
      redirect_to_index
    end

    def edit
      @other_buy = find_model
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

    def find_model
      model.find(params[:id])
    end

    def redirect_to_index
      redirect_to '/admin/other_buy'
    end

    def params_model
      params.require(:other_buy).permit(:title, :price, :type_mode).compact rescue {}
    end

    def model
      OtherBuy
    end

  end
end