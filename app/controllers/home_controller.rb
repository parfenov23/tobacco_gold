require 'vk_message'
class HomeController < ActionController::Base
  before_filter :redirect_test, except: [:callback_vk, :auth]
  def index
  end

  def how_it_works
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

end
