module Admin
  class StockController < CommonController
    # before_action :auth, except: [:index, :to_excel]
    before_action :redirect_to_stock
    def index
      @products = current_company.products
      @products = @products.select { |product| product.product_items.joins(:product_item_counts).where("product_item_counts.count" => 0).uniq.present? } if params[:type] == "not_available"
      @product_items_search = @products.product_items.search_everywhere(params[:search]) if params[:search].present?
    end

    def info
      @product_item = ProductItem.find(params[:id])
      html_form = render_to_string "/admin/stock/_info", :layout => false
      render plain: html_form
    end

    def clear
      current_company.magazines.find(params[:id]).product_item_counts.update_all(count: 0)
      redirect_to :back
    end

    def to_excel
      @products = Product.all
      respond_to do |format|
        format.xls
      end
    end

  end
end
