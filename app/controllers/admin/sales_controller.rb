module Admin
  class SalesController < CommonController

    def index
      @sales = current_user.is_admin? ? model.all : model.where(user_id: current_user.id)
    end

    def new
      @sale = model.new
      @products = Product.all
    end

    def info
      @sale = find_model
    end

    def create
      sales_arr = params[:sales]
      sale = Sale.create(user_id: current_user.id, contact_id: params[:contact_id])
      result = 0
      sales_arr.each do |sale_param|
        count = sale_param[:count].to_i
        item = ProductItem.find(sale_param[:item_id])
        price = ProductPrice.find(sale_param[:price_id])
        result += price.price*count
        item.update({count: (item.count - count)})
        SaleItem.create({sale_id: sale.id, product_item_id: item.id, count: count, product_price_id: price.id})
      end
      sale.update(price: result, profit: sale.find_profit)
      current_cashbox.calculation(params[:cashbox_type], result, true)
      current_user.manager_payments.create(price: result/100*current_user.procent_sale)
      sale.notify_buy
      redirect_to_index
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