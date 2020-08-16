class SuperuserController < ActionController::Base
  # layout "admin"
  before_action :redirect_to_admin

  def index

  end

  def redirect_to_admin
    redirect_to "/admin/admin" if !current_user.superuser rescue true
  end
end
