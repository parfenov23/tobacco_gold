module Api
  class CashboxController < ApiController
    def index
      cashbox = @current_magazine.cashbox
      all_sales = Sale.where(magazine_id: cashbox.magazine_id)
      curr_month_manager_pay = ManagerPayment.where(magazine_id: cashbox.magazine_id).curr_month_price
      curr_month_other_down_price = OtherBuy.where(magazine_id: cashbox.magazine_id).curr_month_price(false).to_i
      curr_month_other_up_price = OtherBuy.where(magazine_id: cashbox.magazine_id).curr_month_price(true).to_i

      curr_profit = all_sales.current_month_profit - curr_month_manager_pay - curr_month_other_down_price + curr_month_other_up_price
      render json: {cashbox:
        [
          {name: "cash", val: cashbox.cash}, 
          {name: "visa", val: cashbox.visa}, 
          {name: "saleToday", val: all_sales.current_day.sum(:price)},
          {name: "profitToday", val: all_sales.current_day_profit},
          {name: "saleMonth", val: all_sales.curr_month_price},
          {name: "profit", val: all_sales.current_month_profit},
          {name: "leftProfit", val: curr_profit}
        ]
      }
    end
  end
end