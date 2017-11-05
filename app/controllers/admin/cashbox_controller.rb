module Admin
  class CashboxController < CommonController
    before_action :redirect_to_stock, except: [:api]

    def index
      Cashbox.create if Cashbox.all.blank? # временное решение
      @current_cashbox = current_cashbox # потом поиск по филиалу

      # @cashbox = Sale.cash_box
      @cashbox = @current_cashbox.cash + @current_cashbox.visa
      @stock_price = Product.stock_price
      @all_sales = Sale.where(magazine_id: current_user.magazine_id)
      
      @last_sales_price = @all_sales.last_sales_price
      @sales_profit = @all_sales.sales_profit
      @curr_month_sales_price = @all_sales.curr_month_price.to_i
      @curr_month_buy_price = Buy.where(magazine_id: current_user.magazine_id).curr_month_price.to_i
      @curr_month_other_up_price = OtherBuy.where(magazine_id: magazine_id).curr_month_price(true).to_i

      @curr_month_other_down_price = OtherBuy.where(magazine_id: magazine_id).curr_month_price(false).to_i
      @curr_month_manager_pay = ManagerPayment.where(magazine_id: magazine_id).curr_month_price
    end

    def to_check
      @current_cashbox = current_cashbox
    end

    def update_cashbox
      curr_cash = params[:cashbox][:cash].to_i
      curr_visa = params[:cashbox][:visa].to_i
      if curr_cash < current_cashbox.cash
        result_cash = current_cashbox.cash - curr_cash
        param_cash = {price: result_cash, title: "сверка кассы наличные", type_mode: false, type_cash: 'cash'}
      elsif curr_cash > current_cashbox.cash
        result_cash = curr_cash - current_cashbox.cash
        param_cash = {price: result_cash, title: "сверка кассы наличные", type_mode: true, type_cash: 'cash'}
      end
        
      if curr_visa < current_cashbox.visa
        result_visa = current_cashbox.visa - curr_visa
        param_visa = {price: result_visa, title: "сверка кассы visa", type_mode: false, type_cash: 'visa'}
      elsif curr_visa > current_cashbox.visa
        result_visa = curr_visa - current_cashbox.visa
        param_visa = {price: result_visa, title: "сверка кассы visa", type_mode: true, type_cash: 'visa'}
      end

      if param_cash.present?
        current_cashbox.calculation(param_cash[:type_cash], param_cash[:price], param_cash[:type_mode])
        param_cash.delete(:type_cash)
        OtherBuy.create(param_cash)
      end
      
      if param_visa.present?
        current_cashbox.calculation(param_visa[:type_cash], param_visa[:price], param_visa[:type_mode])
        param_visa.delete(:type_cash)
        OtherBuy.create(param_visa)
      end

      redirect_to "/admin/cashbox"
    end

    def api
      cashbox = Cashbox.first
      render json: {cashbox:{visa: cashbox.visa, cash: cashbox.cash}}
    end

    private

    def model
      Cashbox
    end
  end
end