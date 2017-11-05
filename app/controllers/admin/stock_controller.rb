module Admin
  class StockController < AdminController
    before_action :auth, except: [:index, :to_excel]
    before_action :redirect_to_stock, except: [:index]
    def index
      @products = Product.all
      @products = Product.all.select { |product| product.product_items.where(count: 0).present? } if params[:type] == "not_available"
    end

    def to_excel
      @products = Product.all
      respond_to do |format|
        format.xls
      end
    end

  end
end
