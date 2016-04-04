class CashboxController < ApplicationController

  def index
    @cashbox = Sale.all.sum(:price) - Buy.all.sum(:price)
  end

end
