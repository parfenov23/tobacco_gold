module Admin
  class AdminController < ActionController::Base
    before_action :redirect_to_stock, except: [:api_sms]
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
      User.where(id: params[:user_id], magazine_id: magazine_id).last.manager_payment_cash
      redirect_to "/admin/users"
    end

    def shift_manager
      html_form = render_to_string "/admin/admin/_shift_manager", :layout => false, :locals => {:current_user => current_user}
      render text: html_form
    end

    def create_shift_manager
      params_shift = {user_id: current_user.id, visa: current_cashbox.visa, sum_sales: current_user.manager_payment_today.sum(:price)}.merge(params[:shift])
      ManagerShift.open_or_close(current_user, params_shift)
      render json: {success: true, url: "/admin/admin" }
    end

    def search
      @product_item = ProductItem.where(barcode: params[:barcode]).last
    end

    def sms_phone
      @all_sms = SmsPhone.where(archive: false, magazine_id: magazine_id)
    end

    private

    def redirect_to_stock
      redirect_to "/" if (current_user.blank? || !current_user.is_admin? && !current_user.is_manager?)
    end

    def current_magazine
      Magazine.find(magazine_id)
    end

    def current_cashbox
      magazine_id.present? ? Cashbox.find_by_magazine_id(magazine_id) : nil
    end

    def magazine_id
      current_user.present? ? current_user.magazine_id : nil
    end

  end
end