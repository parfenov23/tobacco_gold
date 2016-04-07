class CashboxController < ApplicationController

  def index
    @cashbox = Sale.cash_box
    @buy = Buy.sum(:price)
  end

end
