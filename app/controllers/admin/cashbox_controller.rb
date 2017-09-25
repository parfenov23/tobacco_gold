module Admin
  class CashboxController < CommonController
    def index
      Cashbox.create if Cashbox.all.blank? # временное решение
      @current_cashbox = Cashbox.first # потом поиск по филиалу

      # @cashbox = Sale.cash_box
      @cashbox = @current_cashbox.cash + @current_cashbox.visa
      @stock_price = Product.stock_price
      @last_sales_price = Sale.last_sales_price
      @sales_profit = Sale.sales_profit
      @curr_month_sales_price = Sale.curr_month_price.to_i
      @curr_month_buy_price = Buy.curr_month_price.to_i
      @curr_month_other_up_price = OtherBuy.curr_month_price(true).to_i
      @curr_month_other_down_price = OtherBuy.curr_month_price(false).to_i
      @curr_month_manager_pay = ManagerPayment.curr_month_price
    end

    def to_check
      @current_cashbox = current_cashbox
    end

    def update_cashbox
      curr_cash = params[:cashbox][:cash].to_i
      curr_visa = params[:cashbox][:visa].to_i
      if curr_cash < current_cashbox.cash
        result_cash = current_cashbox.cash - curr_cash
        current_cashbox.calculation('cash', result_cash, false)
        OtherBuy.create(price: result_cash, title: "сверка кассы наличные", type_mode: false)
      end
      
      if curr_visa < current_cashbox.visa
        result_visa = current_cashbox.visa - curr_visa
        current_cashbox.calculation('visa', result_visa, false)
        OtherBuy.create(price: result_visa, title: "сверка кассы visa", type_mode: false)
      end
      redirect_to "/admin/cashbox"
    end

    private

    def model
      Cashbox
    end
  end
end