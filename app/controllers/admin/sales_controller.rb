module Admin
  class SalesController < CommonController

    def index
      @sales = current_user.is_admin? ? model.where(magazine_id: magazine_id) : model.where(user_id: current_user.id, magazine_id: magazine_id)
      @sales = @sales.where(["created_at > ?", (Time.now - 2.month)])
      # redirect_to "/admin/admin" if current_user.manager_shifts.current_day.blank? 
    end

    def new
      if params[:order_request].present?
        @order_request = current_company.order_requests.find_by_id(params[:order_request])
        @contact_id = @order_request.contact_id
      end
    end

    def edit
      @sale = find_model
      @products = current_company.products.all_present(magazine_id)
      @contact_id = @sale.contact_id
    end

    def info
      @sale = find_model
    end

    def show
      @sale = find_model if ((find_model.company_id == current_company.id) rescue true )
      if @sale.blank?
        redirect_to "/404"
      else
        respond_to do |format|
          format.html
          format.pdf{
            render pdf: "#{@sale.id}_#{Time.now.to_i}"
          }
        end
      end
    end

    def close
      find_model.close if !find_model.in_stock
      redirect_to "/admin/sales/#{find_model.id}/edit"
    end

    def create
      sale = Sale.create(user_id: current_user.id, contact_id: params[:contact_id])
      create_or_update(sale)
      sale.notify_buy
      params[:typeAction] == "json" ? render_json_success(sale) : redirect_to_index
    end

    def update
      find_model.sale_items.destroy_all
      find_model.update(contact_id: params[:contact_id])
      create_or_update(find_model, "update")
      params[:typeAction] == "json" ? render_json_success(find_model) : redirect_to_index
    end

    def save_order_request
      sales_arr = params[:sales]
      hash_order = {}
      sales_arr.each do |sale_param|
        item = ProductItem.find(sale_param["item_id"])
        count = sale_param["count"].to_i
        price_id = sale_param["price_id"].present? ? sale_param["price_id"].to_i : item.product.product_prices.find_or_create_by(price: sale_param["price"], title: sale_param["price"]).id
        hash_order_count = hash_order["#{item.id}"].present? ? hash_order["#{item.id}"][:count].to_i : 0
        hash_order["#{item.id}"] = {count: hash_order_count + count, price_id: price_id}
      end
      if params[:order_request].present?
        order_request = current_company.order_requests.where(id: params[:order_request]).last
      else
       order_request = OrderRequest.new(company_id: current_company.id, user_id: current_user.id, contact_id: params[:contact_id], status: "waiting", magazine_id: magazine_id)
     end

     order_request.items = hash_order
     order_request.save
     render json: {id: order_request.id}
   end

   def load_content_product_items
    if params[:search].blank?
      @product = current_company.products.find_by_id(params[:id])
      product_items = params[:count] == "all" ? @product.product_items : @product.product_items.all_present(current_magazine.id)
    else
      search_product_items = current_company.products.product_items.full_text_search(params[:search])
      product_items = params[:count] == "all" ? search_product_items : search_product_items.all_present(current_magazine.id)
    end
    html_form = product_items.order(title: :asc).map{|product_item| render_to_string "/admin/sales/helper/_product_item", :layout => false, :locals => {:item => product_item} }.join
    render plain: html_form
  end

  def remove
    find_model.close
    find_model.destroy
    redirect_to_index
  end

  def search_contact
    all_contacts = current_company.contacts
    find_contact = all_contacts.where( params[:barcode].present? ? {barcode: params[:barcode]} : {id: params[:id]}).last
    render json: (find_contact.present? ? find_contact.transfer_to_json : nil)
  end

  private

  def create_or_update(sale, type_sale="create")
    sales_arr = params[:sales]
    result = 0
    hash_order = {}
    sales_arr.each do |sale_param|
      count = sale_param[:count].to_i
      item = ProductItem.find(sale_param[:item_id])
      price = sale_param[:price_id].present? ? ProductPrice.find(sale_param[:price_id]) : item.product.product_prices.find_or_create_by(price: sale_param[:price], title: sale_param[:price])
      result += price.price*count
      curr_count = hash_order["#{item.id}"].present? ? hash_order["#{item.id}"][:count].to_i + count : count
      hash_order["#{item.id}"] = {count: curr_count, price_id: price.id}
      current_item_count = item.product_item_counts.find_by_magazine_id(magazine_id)
      curr_count = current_item_count.count
      current_item_count.update(count: (curr_count - count) )
      item.update({count: (item.count - count)})

      SaleItem.create({sale_id: sale.id, product_item_id: item.id, count: count, product_price_id: price.id, curr_count: curr_count})
    end
    contact = sale.contact
    sale_profit = sale.find_profit

    sale_discount = params[:sale_discount].to_i
    if sale_discount > 0
      if params[:sale_disckount_select] == "proc"
        sale_discount = result/100*sale_discount
      end
      sale_profit -= sale_discount
      result -= sale_discount
    end

    if contact.present? && type_sale == "create"
      purse = contact.purse
      if sale_discount == 0
        purse = contact.purse + (result.to_f/100*contact.current_cashback).round 
      elsif sale_discount > 0
        purse -= sale_discount
      end
      contact.update(purse: purse)
    end

    if params[:order_request].present?
      order = current_company.order_requests.find_by_id(params[:order_request])
      order.update(status: "paid", items: hash_order) if order.present?
    end
    sale.update(price: result, profit: sale_profit, visa: (params[:cashbox_type] == "visa"), magazine_id: current_magazine.id, in_stock: false)
    current_cashbox.calculation(params[:cashbox_type], result, true)
    current_user.manager_payments.create(price: result/100*current_user.procent_sale, magazine_id: magazine_id)
  end

  def find_model
    model.find(params[:id])
  end

  def redirect_to_index
    redirect_to '/admin/sales'
  end

  def params_model
    params.require(:sale).permit(:title).compact rescue {}
  end

  def model
    Sale
  end

end
end