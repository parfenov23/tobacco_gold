module Admin
  class TagsController < CommonController
    # before_action :auth, except: [:index, :to_excel]
    def search
      search_tags = Tag.search_title(current_company.id, params[:search])
      render json: search_tags.transfer_to_json
    end

    def create
      product_item = ProductItem.find(params[:product_item_id])
      if params[:type] == "new"
        tag = Tag.create(title: params[:title], company_id: current_company.id)
      end
      if params[:type] == "add"
        tag = Tag.find(params[:tag_id])
      end
      product_item.tags << tag
      product_item.save
      render json: tag.transfer_to_json
    end

    def remove_product_item
      ProductItemsTag.where(product_item_id: params[:product_item_id], tag_id: params[:id]).destroy_all
      render json: {success: true}
    end

  end
end
