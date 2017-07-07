module Admin
  class AdminController < ActionController::Base
	before_action :redirect_to_stock
    layout "admin"
    def index
  		
  	end

    def manager_payments
      @all_managers = User.where(role: "manager")
    end

    def paid_manager_payments
      ManagerPayment.where(user_id: params[:user_id]).update_all(payment: true)
      redirect_to "/admin/admin/manager_payments"
    end

  	def redirect_to_stock
		  redirect_to "/stock" if !current_user.is_admin? && !current_user.is_manager?
  	end
  end
end