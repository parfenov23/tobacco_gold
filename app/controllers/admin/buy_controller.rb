module Admin
  class BuyController < CommonController

    def index
      @buys = model.all
    end

    def new
      @buy = model.new
      @products = Product.all
    end

    def create
      sales_arr = params[:buy]
      buy = Buy.create
      result = 0
      sales_arr.each do |sale_param|
        count = sale_param[:count].to_i
        item = ProductItem.find(sale_param[:item_id])
        price = sale_param[:price_id].to_i
        result += price*count
        item.update({count: (item.count + count)})
        item.update({barcode: sale_param[:barcode]}) if sale_param[:barcode].present?
        BuyItem.create({buy_id: buy.id, product_item_id: item.id, count: count, price: price})
      end
      buy.update(price: result, def_pay: params[:buy_param][:def_pay], provider_id: params[:buy_param][:provider_id])
      current_cashbox.calculation('cash', result, false) if params[:buy_param][:def_pay] == "1"
      buy.notify_buy
      redirect_to_index
    end

    def def_pay
      find_model.update(def_pay: true)
      current_cashbox.calculation(params[:cashbox_type], find_model.price, false)
      redirect_to_index
    end

    def new_item_product
      ProductItem.create(params_model)
      @products = Product.all
      products_select = render_to_string "/admin/buy/_products_select", :layout => false
      render text: products_select
    end

    def edit
      @buy = find_model
      @products = Product.all
    end

    def update
      find_model.update(params_model)
      redirect_to_index
    end

    def remove
      find_model.destroy
      redirect_to_index
    end

    def info
      @buy = find_model
    end

    private

    def find_model
      model.find(params[:id])
    end

    def redirect_to_index
      redirect_to '/admin/buy'
    end

    def params_model
      params.require(:buy).permit(:title, :product_id, :barcode).compact rescue {}
    end

    def model
      Buy
    end

  end
end