class StockController < ApplicationController

  def index
    @products = Product.all
  end

end
