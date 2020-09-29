module Admin
  class ProductItemsController < CommonController

    def index
      @product_items = find_product.product_items
      @add_title = "#{find_product.title} - "
    end

    def remove
      product_id = find_model.product_id
      find_model.update(archive: true)
      redirect_to '/admin/product_items?product_id=' + product_id.to_s
    end

    def create
      create_model = model.create(params_model)
      if params[:product_items][:count].present?
        create_model.product_item_counts.find_by_magazine_id(current_magazine.id).update(count: params[:product_items][:count])
      end

      current_price = params[:product_items][:current_price].to_f
      find_product_price = create_model.product.product_prices.where(price: current_price).last
      if find_product_price.blank? || !find_product_price.default
        find_product_price = create_model.product.product_prices.find_or_create_by(price: current_price, title: current_price)
        create_model.product_item_magazine_prices.find_or_create_by(magazine_id: current_magazine.id).update(price_id: find_product_price.id)
      end

      params[:typeAction] == "json" ? render_json_success(create_model) : redirect_to_index
    end

    def update
      product_item = find_model
      product_item.update(params_model)
      
      current_price = params[:product_items][:current_price].to_f
      find_product_price = product_item.product.product_prices.where(price: current_price).last
      if find_product_price.blank? || !find_product_price.default
        find_product_price = product_item.product.product_prices.find_or_create_by(price: current_price, title: current_price)
        product_item.product_item_magazine_prices.find_or_create_by(magazine_id: current_magazine.id).update(price_id: find_product_price.id)
      end

      if params[:product_items][:count].present?
        product_item.product_item_counts.find_by_magazine_id(current_magazine.id).update(count: params[:product_items][:count])
      end

      find_product_item_top_magazine = product_item.product_item_top_magazines.where(magazine_id: current_magazine.id).last
      if (params[:product_items][:top] == "1" && find_product_item_top_magazine.blank?)
        product_item.product_item_top_magazines.create(magazine_id: current_magazine.id)
      elsif find_product_item_top_magazine.present?
        find_product_item_top_magazine.destroy
      end

      blank_item = product_item.description.blank? && product_item.image_url.blank?
      jq_script = "$('.btn_item_#{product_item.id}').closest('.blankProductItemDescription').removeClass('blankProductItemDescription');"
      params[:typeAction] == "json" ? render_json_success(find_model, (!blank_item ? jq_script : nil)) : redirect_to_index
    end

    def new
      html_form = render_to_string "/admin/#{model.first_url}/new", :layout => false, :locals => {:current_company => current_company}
      render text: html_form
    end

    def show
      @item = find_model if ((find_model.company_id == current_company.id) rescue true )
      if @item.blank?
        redirect_to "/404"
      else
        respond_to do |format|
          format.html
          format.pdf{
            render pdf: "#{@item.id}_#{Time.now.to_i}",
            margin:  {   
              top:               0,  
              bottom:            0,
              left:              4,
              right:             0 
            }
          }
        end
      end
    end

    private

    def model
      ProductItem
    end

    def find_product
      Product.find(params[:product_id])
    end

    def redirect_to_index
      product_id = params_model[:product_id].present? ? params_model[:product_id] : find_model.product_id
      redirect_to '/admin/product_items?product_id=' + product_id
    end
  end
end