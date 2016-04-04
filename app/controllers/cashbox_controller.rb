class CashboxController < ApplicationController

  def index
    @cashbox = Sale.sum(:price)
    @buy = Buy.sum(:price)
  end

end
