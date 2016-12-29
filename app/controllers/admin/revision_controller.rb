module Admin
  class RevisionController < AdminController

    def index
      @products = Product.all
    end

    def create
      product_item_keys = params[:product_items].keys
      sale = Sale.create
      product = Product.find(params[:product_item])
      result = 0
      product_item_keys.each do |item_key|
        product_item = ProductItem.find(item_key)
        revision_count = product_item.count - params[:product_items][item_key].first.to_i
        if revision_count > 0
          price = product.current_price
          result += price*revision_count
          product_item.update({count: (product_item.count - revision_count)})
          SaleItem.create({sale_id: sale.id, product_item_id: product_item.id, count: revision_count, product_price_id: product.current_price_model.id})
        end
      end
      sale.sale_items.count > 0 ? ({e: sale.update(price: result),  f: sale.notify_buy}) : sale.destroy
      
      redirect_to :back
    end

  end
end
