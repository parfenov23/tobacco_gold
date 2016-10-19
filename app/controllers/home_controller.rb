class HomeController < ActionController::Base
  before_filter :redirect_test, except: [:callback_vk, :auth]
  def index
  end

  def how_it_works
  end

  def redirect_test
    redirect_to "/stock" 
  end

  def auth
    redirect_to "/users/sign_in"
  end

  def login
  end

  def registration
  end

  def callback_vk
    VkMessage
    render text: "5bbf068d"
  end

  def item
    @item = Item.find(params[:id])
  end

end
