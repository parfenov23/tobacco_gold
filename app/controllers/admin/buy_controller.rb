module Admin
  class BuyController < CommonController

    def index
      @buys = model.where(magazine_id: magazine_id)
    end

    def new
      @buy = model.new
      @products = current_company.products
    end

    def create
      sales_arr = params[:buy]
      buy = Buy.create
      result = 0
      hash_update_price = {}
      sales_arr.each do |sale_param|
        count = sale_param[:count].to_i
        item = ProductItem.find(sale_param[:item_id])
        price = sale_param[:price].to_f
        result += price*count
        hash_update_price[item.product_id.to_s] = price if hash_update_price[item.product_id.to_s].to_i < price
        current_item_count = item.product_item_counts.where(magazine_id: magazine_id).last
        curr_count = current_item_count.count
        current_item_count.update(count: (curr_count + count) )
        item.update({count: (item.count + count)})
        item.update({barcode: sale_param[:barcode]}) if sale_param[:barcode].present?
        BuyItem.create({buy_id: buy.id, product_item_id: item.id, count: count, price: price, curr_count: curr_count})
      end
      buy.update(price: result, def_pay: params[:buy_param][:def_pay], provider_id: params[:provider_id], magazine_id: magazine_id)
      current_cashbox.calculation(params[:cashbox_type], result, false) if params[:buy_param][:def_pay] == "1"
      if params[:provider_id].present?
        hash_update_price.each do |k, v| 
          provider = Provider.find(params[:provider_id])
          curr_item = provider.provider_items.where(product_id: k).last
          if curr_item.present?
            curr_item.update(price: v) if curr_item.price != v
          else
            provider.provider_items.create(price: v, product_id: k)
          end
        end
      end
      buy.notify_buy
      params[:typeAction] == "json" ? render_json_success(buy) : redirect_to_index
    end

    def def_pay
      sum_cash = params[:sum_cash].to_i
      buy = find_model
      buy.update(paid_out: buy.paid_out.to_i + sum_cash)
      provider = buy.provider
      if sum_cash != 0
        if provider.phone.present? && params[:cashbox_type] == "visa" && params[:auto][:cash] == "1"
          SmsPhone.transfer_cash(current_user.magazine, provider.phone, sum_cash)
        end
        current_cashbox.calculation(params[:cashbox_type], sum_cash, false)
        if buy.balance_of_pay <= 0
          find_model.update(def_pay: true)
        end
      else
        find_model.update(def_pay: true)
      end
      jq_sript = "$('a.btn_def_pay_#{buy.id}').hide();"
      render_json_success(buy, jq_sript)
    end

    def new_item_product
      product_item = ProductItem.create(params_model)
      render_json_success(product_item)
    end

    def edit
      @buy = find_model
      @products = current_company.products
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
      @buy = find_model if ((find_model.company_id == current_company.id) rescue true )
      redirect_to "/404" if @buy.blank?
      render layout: false
    end

    def search_result
      agent = Mechanize.new
      @find_arr = []
      query_arr = params[:query].split("\r\n").uniq
      product = Product.find(params[:product_id])
      provider = Provider.find(params[:provider_id])
      provider_item = provider.provider_items.find_by_product_id(params[:product_id])
      text_replace = provider_item.present? ? provider_item.text_replace : nil
      query_arr.each do |query_title|
        query = clear_query_search(query_title, product.title, text_replace)
        title = translate_text(query)
        full_title = (product.title + " - " + title)
        find_buy_search = BuySearch.where(title: full_title, company_id: current_company.id).last
        result = find_buy_search.blank? ? ProductItem.where(product_id: params[:product_id]).accurate_search_title(title, 0.8) : find_buy_search.product_item
        count_pi = result.present? ? result.current_count(current_user.magazine).to_i : 0

        @find_arr += [ { full_title: query_title, title: title, min_title: query, result: (result.present? ? result.id : nil) , count_pi: count_pi} ]
      end 
    end

    def search_result_update
      find_title = BuySearch.where(title: params[:title], company_id: current_company.id).last
      has_update = {product_item_id: params[:product_item_id], title: params[:title], company_id: current_company.id}
      find_title.present? ? find_title.update(has_update) : BuySearch.create(has_update)
      find_product_item_count = ProductItem.find(params[:product_item_id]).current_count(current_user.magazine)
      render json: {count: find_product_item_count}
    end

    def form_search_result
      @arr_hash = []
      i = -1
      params[:title].each do |title|
        count = params[:count][i+=1].to_i
        @arr_hash << {title: title.gsub("  ", " "), count: count} if count > 0
      end
    end

    def paid_out
      @model = find_model
      html_form = render_to_string "/admin/buy/paid_out", :layout => false, :locals => {:current_company => current_company}
      render text: @model.magazine_id == current_user.magazine_id ? html_form : "404"
    end

    private

    def redirect_to_index
      redirect_to '/admin/buy'
    end

    def params_model
      params.require(:buy).permit(:title, :product_id, :barcode).compact rescue {}
    end

    def model
      Buy
    end

    def clear_query_search(query, product, text_replace=nil)
      query = query.mb_chars.downcase.to_s
      reg = Regexp.new(/Табак ([а-яА-Я].+?|[a-zA-Z].+?) (\(50гр\)|\(50 гр\)|\"([а-яА-Я].+?|[a-zA-Z].+?)\")/)
      reg2 = text_replace.present? ? text_replace.to_s.match(/.*/).to_a.first.to_regexp : Regexp.new(/.*/)
      query = query.gsub(reg, "").gsub("-", " ").gsub("  ", " ")
      reg_filter = query.match(reg2).to_a.last rescue nil
      (reg_filter || query)
    end

    def translate_text(query)
      agent = Mechanize.new
      url_source = "http://translate.meta.ua/ajax/"
      id_translate = JSON.parse(agent.post("#{url_source}?sn=save_source", {text_source: query, lang_from: "ru", lang_to: "en"}).body)["ui"]
      page = agent.get("#{url_source}?sn=get_translate&translate_uniqid=#{id_translate}&lang_from=ru&lang_to=en&translate_part=0")
      JSON.parse(page.body)["translate"]
    end

  end
end