module Admin
  class OtherBuyController < CommonController

    def index
      @other_buys = model.where(magazine_id: magazine_id).order("created_at DESC")
    end

    def create
      other_buy = model.create(params_model)
      current_cashbox.calculation(params[:cashbox_type], other_buy.price, other_buy.type_mode)
      other_buy.notify_buy
      redirect_to_index
    end

    private

    def model
      OtherBuy
    end

  end
end