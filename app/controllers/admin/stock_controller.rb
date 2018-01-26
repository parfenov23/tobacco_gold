module Admin
  class StockController < AdminController
    # before_action :auth, except: [:index, :to_excel]
    before_action :redirect_to_stock
    def index
      @products = Product.all
      # @products = Product.all.select { |product| product.product_items.where(count: 0).present? } if params[:type] == "not_available"
    end

    def info
      @product_item = ProductItem.find(params[:id])
      html_form = render_to_string "/admin/stock/_info", :layout => false
      render text: html_form
    end

    def to_excel
      @products = Product.all
      respond_to do |format|
        format.xls
      end
    end

  end
end
