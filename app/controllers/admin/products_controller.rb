module Admin
  class ProductsController < CommonController

    def index
      @models = params[:category].blank? ? current_company.products : current_company.products.where(category_id: params[:category])
    end

    def create
      create_model = model.create(params_model)
      current_price = params[:products][:current_price]
      if current_price.to_f > 0
        create_model.product_prices.find_or_create_by(price: current_price.to_f, title: current_price, default: true)
      end
      params[:typeAction] == "json" ? render_json_success(create_model) : redirect_to_index
    end

    def update
      find_model.update(params_model) if ((find_model.company_id == current_company.id) rescue true )
      current_price = params[:products][:current_price]
      if current_price.to_f > 0
        find_model.product_prices.update_all(default: false)
        new_price = find_model.product_prices.find_or_create_by(price: current_price.to_f, title: current_price).update(default: true)
      end
      params[:typeAction] == "json" ? render_json_success(find_model) : redirect_to_index
    end

    def remove
      find_model.update(archive: true)
      redirect_to_index
    end

    private

    def model
      Product
    end
  end
end
