class BuyController < ApplicationController

  def index
    @buys = model.all
  end

  def new
    @buy = model.new
    @products = Product.all
  end

  def create
    sales_arr = params[:buy]
    buy = Buy.create
    result = 0
    sales_arr.each do |sale_param|
      count = sale_param[:count].to_i
      item = ProductItem.find(sale_param[:item_id])
      price = sale_param[:price_id].to_i
      result += price*count
      item.update({ count: (item.count + count) })
      BuyItem.create({buy_id: buy.id, product_item_id: item.id, count: count, price: price})
    end
    buy.update(price: result)
    redirect_to_index
  end

  def edit
    @sale = find_model
  end

  def update
    find_model.update(params_model)
    redirect_to_index
  end

  def remove
    find_model.destroy
    redirect_to_index
  end

  def info
    @buy = find_model
  end

  private

  def find_model
    model.find(params[:id])
  end

  def redirect_to_index
    redirect_to '/buy'
  end

  def params_model
    params.require(:buy).permit(:title).compact rescue {}
  end

  def model
    Buy
  end

end
