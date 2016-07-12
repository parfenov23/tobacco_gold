module ApplicationHelper
  def current_user
    session[:user_pass] == 'parfenov407'
  end
end
