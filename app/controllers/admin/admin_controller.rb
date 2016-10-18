module Admin
  class AdminController < ActionController::Base
    layout "admin"
    def index
  		redirect_to "/stock" if !current_user.present?
  	end
  end
end