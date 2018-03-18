module Admin
  class ProductsController < CommonController

    def index
      @models = params[:category].blank? ? current_company.products : current_company.products.where(category_id: params[:category])
    end

    private

    def model
      Product
    end
  end
end
