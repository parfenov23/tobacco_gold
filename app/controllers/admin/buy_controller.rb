module Admin
  class BuyController < CommonController

    def index
      @buys = model.where(magazine_id: magazine_id)
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
        current_item_count = item.product_item_counts.where(magazine_id: magazine_id).last
        current_item_count = item.product_item_counts.create(magazine_id: magazine_id, count: 0) if current_item_count.blank?
        current_item_count.update(count: (current_item_count.count + count) )
        item.update({count: (item.count + count)})
        item.update({barcode: sale_param[:barcode]}) if sale_param[:barcode].present?
        BuyItem.create({buy_id: buy.id, product_item_id: item.id, count: count, price: price})
      end
      buy.update(price: result, def_pay: params[:buy_param][:def_pay], provider_id: params[:buy_param][:provider_id], magazine_id: magazine_id)
      current_cashbox.calculation('cash', result, false) if params[:buy_param][:def_pay] == "1"
      buy.notify_buy(current_cashbox)
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

    def search_result
      agent = Mechanize.new
      key = "trnsl.1.1.20171111T163230Z.04bdb3d7a3cc5cc3.ba4f5477c9fa02e2c6c9febb79947b65de104637"
      query = clear_query_search(params[:query], Product.find(params[:product_id]).title)
      arr_title = []
      query.gsub(", ",",").split(",").uniq.each do |t|
        page = agent.post("https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{key}&text=#{t}&lang=ru-en")
        arr_title << JSON.parse(page.body)["text"].first
      end
      @find_arr = []
      arr_title.each do |title|
        result = ProductItem.where(product_id: params[:product_id]).accurate_search_title(title)
        @find_arr += [[title, (result.present? ? result.id : nil)]]
      end
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

    def clear_query_search(query, product)
      case product
      when "Adalya"
        query.gsub("\"Адалья\"", "Адалья").gsub("\r\n", ", ").gsub(/Табак [а-я].+? (Адалья|Адалия) /, "").gsub("Табак Adalya (50гр) ", "")
      when "Serbetli"
        query.gsub("\"Щербетли\"", "Щербетли").gsub("\r\n", ", ").gsub(/Табак [а-я].+? (Щербетли|Щербет) /, "").gsub("Табак Serbetli (50гр) ", "")
      when "Smyrna"
        query.gsub("\"Смирна\"", "Смирна").gsub("\r\n", ", ").gsub(/Табак [а-я].+? (Смирна|Смирна) /, "").gsub("Табак SMYRNA (50гр) ", "")
      when "Afzal"
        query.gsub("\"Афзал\"", "Афзал").gsub("\r\n", ", ").gsub(/Табак [а-я].+? (Афзал|Афзал) /, "").gsub("Табак Афзал (50гр) ", "")
      when "AL Fakher" 
        query.gsub("\"Аль Факер\"", "Аль Факер").gsub("\r\n", ", ").gsub(/Табак [а-я].+? (Аль Факер|Аль Факер) /, "").gsub("Табак Al Fakher (50гр) ", "")
      end
    end

  end
end