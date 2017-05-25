require 'vk_message'
class HomeController < ActionController::Base
  # before_filter :redirect_test, except: [:callback_vk, :auth]
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

  def send_item_to_basket
    params_r = params[:request]
    basket = {}
    session[:items].map { |item| basket[item.to_s] = basket[item.to_s].to_i + 1 }
    contact_phone = params_r[:user_phone].gsub(/\D/, '')
    contact = Contact.create(first_name: params_r[:user_name], phone: contact_phone)
    order = OrderRequest.create(user_id: (current_user.id rescue nil), user_name: params_r[:user_name], 
      user_phone: params_r[:user_phone], status: "waiting", items: basket)

    order.update(contact_id: (contact.save ? contact.id : Contact.find_by_phone(contact_phone).id ) )
    session[:items] = nil
    order.notify
    render json: {id: order.id}
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
