module Admin
  class SalesController < CommonController

    def index
      @sales = current_user.is_admin? ? model.where(magazine_id: magazine_id) : model.where(user_id: current_user.id, magazine_id: magazine_id)
      @sales = @sales.where(["created_at > ?", Time.now.beginning_of_year])
    end

    def new
      @sale = model.new
      @products = current_company.products.all_present(magazine_id)
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

    def create
      sales_arr = params[:sales]
      sale = Sale.create(user_id: current_user.id, contact_id: params[:contact_id])
      result = 0
      hash_order = {}
      sales_arr.each do |sale_param|
        count = sale_param[:count].to_i
        item = ProductItem.find(sale_param[:item_id])
        price = ProductPrice.find(sale_param[:price_id])
        result += price.price*count
        curr_count = hash_order["#{item.id}"].present? ? hash_order["#{item.id}"][:count].to_i + count : count
        hash_order["#{item.id}"] = {count: curr_count, price_id: sale_param[:price_id].to_i}

        current_item_count = item.product_item_counts.find_by_magazine_id(magazine_id)
        curr_count = current_item_count.count
        current_item_count.update(count: (curr_count - count) )
        item.update({count: (item.count - count)})
        SaleItem.create({sale_id: sale.id, product_item_id: item.id, count: count, product_price_id: price.id, curr_count: curr_count})
      end
      contact = sale.contact
      sale_profit = sale.find_profit

      if contact.present?
        purse = contact.purse
        if params[:cashback_type] == "stash"
          purse = contact.purse + (result.to_f/100*contact.cashback).round 
        elsif params[:cashback_type] == "dickount"
          sale_profit = sale_profit >= purse ? (sale_profit - purse) : 0
          if result >= purse
            result -= purse
            purse = 0
          else
            purse -= result
            result = 0
          end
        end
        contact.update(purse: purse)
      end

      if params[:order_request].present?
        order = current_company.order_requests.where(id: params[:order_request]).last
        order.update(status: "paid", items: hash_order) if order.present?
      end

      sale.update(price: result, profit: sale_profit, visa: (params[:cashbox_type] == "visa"), magazine_id: params[:magazine_id])
      current_cashbox.calculation(params[:cashbox_type], result, true)
      current_user.manager_payments.create(price: result/100*current_user.procent_sale, magazine_id: magazine_id)
      sale.notify_buy
      redirect_to_index
    end

    def save_order_request
      sales_arr = params[:sales]
      hash_order = {}
      sales_arr.each do |sale_param|
        item = ProductItem.find(sale_param[:item_id])
        count = sale_param[:count].to_i
        hash_order["#{item.id}"] = {count: hash_order["#{item.id}"].to_i + count, price_id: sale_param[:price_id].to_i}
      end
      if params[:order_request].present?
        order_request = current_company.order_requests.where(id: params[:order_request]).last
      else
       order_request = OrderRequest.new(company_id: current_company.id, user_id: current_user.id, contact_id: params[:contact_id], status: "waiting")
     end

     order_request.items = hash_order
     order_request.save
     render json: {id: order_request.id}
   end

   def load_content_product_items

    @products = Product.where(id: params[:id], company_id: current_company.id) if params[:id].present?
    @products = Product.where(id: (ProductItem.where(barcode: params[:barcode]).last.product_id rescue nil), company_id: current_company.id) if params[:barcode].present?
    @products = Product.where(id: ProductItem.find(params[:product_item_id]).product_id, company_id: current_company.id) if params[:product_item_id].present?

    html_form = render_to_string "/admin/sales/_select_product_items", :layout => false
    render text: html_form
  end

  def edit
    @sale = find_model
  end

  def update
    find_model.update(params_model)
    redirect_to_index
  end

  def remove
    find_model.destroy
    redirect_to_index
  end

  def search_contact
    all_contacts = current_company.contacts
    find_contact = all_contacts.where( params[:barcode].present? ? {barcode: params[:barcode]} : {id: params[:id]}).last
    render json: (find_contact.present? ? find_contact.transfer_to_json : nil)
  end

  private

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