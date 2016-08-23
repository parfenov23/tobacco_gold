class CashboxController < ApplicationController

  def index
    @cashbox = Sale.cash_box
    @stock_price = Product.stock_price
    @last_sales_price = Sale.last_sales_price
    @sales_profit = Sale.sales_profit
    @curr_month_sales_price = Sale.curr_month_price
    @curr_month_buy_price = Buy.curr_month_price
  end

end
