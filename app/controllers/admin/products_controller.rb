module Admin
  class ProductsController < AdminController

    def index
      @products = model.all
    end

    def new
      @product = model.new
    end

    def create
      model.create(params_product)
      redirect_to_index
    end

    def edit
      @product = find_product
    end

    def update
      find_product.update(params_product)
      redirect_to_index
    end

    def remove
      find_product.destroy
      redirect_to_index
    end

    private

    def find_product
      model.find(params[:id])
    end

    def model
      Product
    end

    def redirect_to_index
      redirect_to '/admin/products'
    end

    def params_product
      params.require(model.to_s.downcase.to_sym).permit(model.column_names).compact.select { |k, v| v != "" } rescue {}
    end
  end
end
