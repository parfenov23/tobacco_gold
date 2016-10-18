class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  layout :set_layout_for_devise
  #skip_before_filter :verify_authenticity_token, :only => [:index, :show]

  def set_layout_for_devise
    "home" if devise_controller? # && resource_name == :user && action_name == 'new'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:login, :avatar, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:login, :avatar, :email, :password, :password_confirmation, :current_password) }
  end

end
