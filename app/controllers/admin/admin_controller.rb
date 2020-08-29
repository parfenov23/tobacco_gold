module Admin
  class AdminController < ActionController::Base
    include ApplicationHelper
    before_action :redirect_to_stock, except: [:api_sms]
    before_action :current_company
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

    def update_photo
      Thread.new do
        # Rails.application.executor.wrap do
        company_products_ids = Company.find(90).products.ids
        product_items = ProductItem.where(product_id: company_products_ids).where(image_url: nil)
        agent = Mechanize.new
        count_pi = product_items.count
        p "Найдено: #{count_pi} товаров"
        count = 0
        curr_folder = "#{Rails.root}/tmp/load_png/"
        Dir.mkdir(curr_folder) unless File.exists?(curr_folder)
        product_items.each do |product_item|
          barcodes = product_item.barcode.split(",")
          barcodes.each do |barcode|
            bar_add = false
            ["jpg", "JPG"].each do |type_jpg|
              url = "http://svet2020.beget.tech/wp-content/uploads/product_items/#{barcode}.#{type_jpg}"
              page = agent.get(url) rescue false
              if page
                bar_add = true
                p "Добавляю картинку"
                count += 1
                time = Time.now.to_i.to_s
                path_img = "#{Rails.root}/tmp/load_png/"+time+"_img."+url.split(".").last
                myfile = IO.sysopen(path_img, "wb+")
                tmp_img = IO.new(myfile,"wb")
                tmp_img.write open(URI.encode(url)).read
                if File.exist?(path_img)
                  product_item.image_url = File.open path_img
                  product_item.save
                end
                break
              end
            end
            break if bar_add
          end
          count_pi -= 1
          p "осталось: #{count_pi}"
          p "текущее количество: #{count}"
        end
        FileUtils.rm_rf(curr_folder)
        # end
      end
      render json: {success: true}
    end

    private

    def redirect_to_stock
      present_user = (current_user.blank? || !current_user.is_admin? && !current_user.is_manager?)
      if current_user.present?
        if current_company.setting_nav.present? && curr_hash_nav_li.present? && curr_hash_nav_li[:display] != false && curr_hash_nav_li[:url] != "/admin/admin"
          redirect_to "/" if !current_company.setting_nav.split(",").include?(curr_hash_nav_li[:url])
        end
        if  params[:controller] != "admin/order_payments"
          redirect_to "/admin/order_payments"  if !current_company.demo_sign_in_time
        end
      end
      redirect_to "/" if present_user
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

    def current_company
      @current_company = current_user.magazine.company
      @current_company
    end

  end
end