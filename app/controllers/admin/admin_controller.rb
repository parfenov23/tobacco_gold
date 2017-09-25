module Admin
  class AdminController < ActionController::Base
    before_action :redirect_to_stock
    layout "admin"
    def index

    end

    def manager_payments
      @all_managers = User.all
    end

    def paid_manager_payments
      all_manager_pay = ManagerPayment.where(user_id: params[:user_id])
      current_cashbox.calculation('cash', all_manager_pay.sum(:price), false)
      all_manager_pay.update_all(payment: true)
      redirect_to "/admin/admin/manager_payments"
    end

    def search
      @product_item = ProductItem.where(barcode: params[:barcode]).last
    end

    def redirect_to_stock
      redirect_to "/stock" if !current_user.is_admin? && !current_user.is_manager?
    end

    def current_cashbox
      Cashbox.first
    end
  end
end