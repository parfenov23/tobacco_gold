module Admin
  class ProductsController < CommonController

    def index
      @models = params[:category].blank? ? model.all : Product.where(category_id: params[:category])
    end

    private

    def model
      Product
    end
  end
end
