module Api
  class CategoriesController < ApiController
    def index
      render json: current_company.categories.joins(products: {product_items: :product_item_counts}).where(["product_item_counts.count > ? AND product_item_counts.magazine_id = ?", 0, current_magazine.id]).uniq.to_json
    end

    def show
      render json: Category.find(params[:id]).as_json
    end

    def products
      render json: Category.find(params[:id]).products.joins(product_items: :product_item_counts).where(["product_item_counts.count > ? AND product_item_counts.magazine_id = ?", 0, current_magazine.id]).uniq.transfer_to_json
    end
  end
end