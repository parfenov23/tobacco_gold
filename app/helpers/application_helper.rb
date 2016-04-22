module ApplicationHelper
  def current_user
    session[:user_pass] == 'lolopo123'
  end
end
