module Admin
  class HookahCashController < AdminController

    def index
      @hookah_cashs = model.all.order("created_at DESC")
    end

    def new
      @hookah_cash = model.new
    end

    def create
      hookah_cash = model.create(params_model)
      hookah_cash.notify_buy
      redirect_to_index
    end

    def edit
      @hookah_cash = find_model
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
      redirect_to '/admin/hookah_cash'
    end

    def params_model
      params.require(:hookah_cash).permit(:title, :price, :type_mode).compact rescue {}
    end

    def model
      HookahCash
    end

  end
end