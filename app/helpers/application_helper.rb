module ApplicationHelper
  def current_user
    session[:user_pass] == 'parfenov407'
  end

  def check_if_true(item)
    if(item == 'true' or item == true or item == 1 or item == '1')
      return true
    else
      return false
    end
  end
end
