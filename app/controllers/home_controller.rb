class HomeController < ActionController::Base
  layout "admin"

  def index
    redirect_to "/admin/admin" if current_user.admin rescue false
  end
end
