module Admin
  class AdminController < ActionController::Base
	before_action :redirect_to_stock
    layout "admin"
    def index
  		
  	end

  	def redirect_to_stock
		redirect_to "/stock" if !current_user.admin
  	end
  end
end