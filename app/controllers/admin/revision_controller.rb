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
        current_item_count = product_item.product_item_counts.find_by_magazine_id(magazine_id)
        curr_count = current_item_count.count
        revision_count = curr_count - params[:product_items][item_key].first.to_i
        if revision_count > 0
          price = product_item.last_buy_price
          result += price*revision_count
          current_item_count.update(count: (curr_count - revision_count) )
          # product_item.update({count: (product_item.count - revision_count)})
          SaleItem.create({sale_id: sale.id, product_item_id: product_item.id, count: revision_count, price_int: price, curr_count: curr_count})
        end
      end
      if sale.sale_items.count > 0 
        sale.update(price: result, profit: sale.find_profit, magazine_id: magazine_id)
        current_cashbox.calculation('cash', result, true)
        sale.notify_buy
      else
        sale.destroy
      end
      redirect_to :back
    end

  end
end
