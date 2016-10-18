module Admin
  class CashboxController < AdminController

    def index
      @cashbox = Sale.cash_box
      @stock_price = Product.stock_price
      @last_sales_price = Sale.last_sales_price
      @sales_profit = Sale.sales_profit
      @curr_month_sales_price = Sale.curr_month_price.to_i
      @curr_month_buy_price = Buy.curr_month_price.to_i
      @curr_month_other_up_price = OtherBuy.curr_month_price(true).to_i
      @curr_month_other_down_price = OtherBuy.curr_month_price(false).to_i
    end

  end
end