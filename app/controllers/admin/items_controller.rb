module Admin
  class ItemsController < AdminController
    def index
      @all_categories = Category.all
      if params[:category_id].blank?
        @items = Item.all
      else
        @items = Category.find(params[:category_id]).items
      end
    end

    def new
      @all_categries = Category.all
      @item = Item.new
    end

    def create
      item = Item.create(params_item)
      if params[:file].present?
        params[:file].each do |params_file|
          item.create_all_img(params_file)
        end
      end
      redirect_to "/admin/items/#{item.id}/edit"
    end

    def edit
      @all_categries = Category.all
      @item = find_item
    end

    def update
      item = find_item
      item.update(params_item)
      if params[:file].present?
        params[:file].each do |params_file|
          item.create_all_img(params_file)
        end
      end
      redirect_to :back
    end

    def remove
      find_item.destroy
      redirect_to :back
    end

    private

    def find_item
      Item.find(params[:id])
    end

    def params_item
      params.require(:item).permit(:first_name, :category_id, :description, :img_id)
    end
  end
end