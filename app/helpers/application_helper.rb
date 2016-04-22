module ApplicationHelper
  def current_user_help
    session[:user_pass] == 'lolopo123'
  end
end
