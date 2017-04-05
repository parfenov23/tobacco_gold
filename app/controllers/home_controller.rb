require 'vk_message'
class HomeController < ActionController::Base
  before_filter :redirect_test, except: [:callback_vk, :auth]
  def index
  end

  def how_it_works
  end

  def add_item_to_basket
    arr = params[:count].to_i.times.map{|c| params[:item_id].to_i}
    session[:items] = session[:items].present? ? (session[:items] + arr) : arr
    render json: {all: session[:items], count: session[:items].uniq.count}
  end

  def rm_item_to_basket
    session[:items].delete(params[:item_id].to_i)
    @all_items = ProductItem.where(id: session[:items])
    @all_sum = @all_items.map{|pi| pi.product.current_price*session[:items].count(pi.id)}.sum
    render json: {all: session[:items], count: session[:items].uniq.count, total_price: @all_sum}
  end

  def redirect_test
    redirect_to "/stock" if ((!current_user.admin) rescue true)
  end

  def auth
    redirect_to "/users/sign_in"
  end

  def login
  end

  def registration
  end

  def callback_vk
    VkMessage.message_price(params)
    render text: "ok"
  end

  def item
    @item = ProductItem.find(params[:id]) 
  end

  def buy_rate
    @all_items = ProductItem.where(id: session[:items])
    @all_sum = @all_items.map{|pi| pi.product.current_price*session[:items].count(pi.id)}.sum
  end

end
