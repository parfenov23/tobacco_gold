require 'vk_message'
class HomeController < ActionController::Base
  # before_filter :redirect_test, except: [:callback_vk, :auth]
  def index
    @items = if params[:category_id].present?   
      ProductItem.where(product_id: Category.find(params[:category_id]).products.map(&:id) )
    elsif params[:product_id].present? 
      Product.find(params[:product_id]).product_items
    else
      arr_ids = ProductItem.where(["count > ? ", 0]).map{|pi| {id: pi.id, count: pi.sale_items.count} if pi.count > 0}.compact.sort_by { |hsh| hsh[:count] }.reverse.first(20).map{|pi| pi[:id]}
      ProductItem.where(id: arr_ids)
    end
    if params[:price].present?
      ids = @items.map do |item| 
        item_price = item.product.current_price
        item.id if item_price >= params[:price][:from].to_i && item_price <= params[:price][:to].to_i
      end.compact
      @items = ProductItem.where(id: ids)
    end
  end

  def how_it_works
  end

  def add_item_to_basket
    arr = params[:count].to_i.times.map{|c| params[:item_id].to_i}
    # binding.pry
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
    contact = current_user.contact
    if contact.blank?
      contact_phone = params_r[:user_phone].gsub(/\D/, '')
      contact = Contact.new(first_name: params_r[:user_name], phone: contact_phone)
      contact = contact.save ? contact : Contact.find_by_phone(contact_phone)
      current_user.update(contact_id: contact.id)
    end
    order = OrderRequest.create(user_id: (current_user.id rescue nil), user_name: params_r[:user_name], 
      user_phone: params_r[:user_phone], status: "waiting", items: basket, comment: params_r[:comment])

    order.update(contact_id: contact.id)
    session[:items] = nil
    order.notify if Rails.env.production?
    render json: {id: order.id}
  end

  def callback_vk
    VkMessage.message_price(params)
    render text: "ok"
  end

  def item
    @item = ProductItem.find(params[:id]) 
  end

  def mix_box
    @mix_box = MixBox.find(params[:id])
  end

  def buy_rate
    current_user.blank? ? (redirect_to "/users/sign_up") : nil
    @all_items = ProductItem.where(id: session[:items])
    @all_sum = @all_items.map{|pi| pi.product.current_price*session[:items].count(pi.id)}.sum
  end

  def cabinet
    @visible_bar = false
    @contact = current_user.contact
  end

  def show_sale
    @sale = current_user.contact.sales.where(id: params[:id]).last
    if @sale.present?
      respond_to do |format|
        format.html
        format.pdf{
          render pdf: "#{@sale.id}_#{Time.now.to_i}"
        }
      end
    else
      redirect_to "/cabinet"
    end
  end

end
