class HomeController < ApplicationController
  before_action :auth, except: [:auth, :auth_user]

  def auth

  end

  def auth_user
    session[:user_pass] = params[:pass]
    redirect_to "/"
  end
end
