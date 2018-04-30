module Api
  class CategoriesController < ApiController
    def index
      render json: Category.all.where(company_id: current_company.id).to_json
    end

    def show
      render json: Category.find(params[:id]).as_json
    end

    def products
      render json: Category.find(params[:id]).products.transfer_to_json
    end
  end
end