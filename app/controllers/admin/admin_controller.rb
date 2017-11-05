module Admin
  class AdminController < ActionController::Base
    before_action :redirect_to_stock
    layout "admin"
    
    def index
      if params[:stat] == "all" 
        @sum_sales = current_user.sales.sum(:price)
        @cash_money = current_user.sales.where(visa: false).sum(:price)
        @cash_visa = current_user.sales.where(visa: true).sum(:price)
        @average_check = current_user.manager_average_check_all
        @manager_balance = current_user.manager_payments.sum(:price)
        @all_count_sales = current_user.sales.count
      elsif params[:stat] == "month"
        @sum_sales = current_user.manager_payment_month.sum(:price)
        @cash_money = current_user.manager_payment_month.where(visa: false).sum(:price)
        @cash_visa = current_user.manager_payment_month.where(visa: true).sum(:price)
        @average_check = current_user.manager_average_check_month
        @manager_balance = current_user.manager_balance_month
        @all_count_sales = current_user.manager_payment_month.count
      else
        @sum_sales = current_user.manager_payment_today.sum(:price)
        @cash_money = current_user.manager_payment_today.where(visa: false).sum(:price)
        @cash_visa = current_user.manager_payment_today.where(visa: true).sum(:price)
        @average_check = current_user.manager_average_check_today
        @manager_balance = current_user.manager_balance_today
        @all_count_sales = current_user.manager_payment_today.count
      end
    end

    def manager_payments
      @all_managers = User.where(magazine_id: magazine_id)
    end

    def paid_manager_payments
      all_manager_pay = ManagerPayment.where(user_id: params[:user_id], payment: false, magazine_id: magazine_id)
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
      Cashbox.find_by_magazine_id(magazine_id)
    end

    def magazine_id
      current_user.magazine_id
    end
  end
end