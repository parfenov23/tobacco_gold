class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_action :auth

  def auth
    result = session[:user_pass] == 'parfenov407'
    redirect_to '/stock' if !result
  end
end
