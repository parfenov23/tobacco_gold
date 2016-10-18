module Admin
  class CategoriesController < AdminController
    def index
      @categories = Category.all
    end

    def new
      @category = Category.new
    end

    def create
      Category.create(params_category)
      redirect_to "/admin/categories"
    end

    def edit
      @category = find_category
    end

    def update
      find_category.update(params_category)
      redirect_to "/admin/categories"
    end

    def remove
      find_category.destroy
      redirect_to "/admin/categories"
    end

    private

    def find_category
      Category.find(params[:id])
    end

    def params_category
      params.require(:category).permit(:first_name)
    end
  end
end