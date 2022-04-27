module Admin
  class TransfersController < CommonController

    def index
      @models = current_company.transfers
    end

    def new
      @trnasfer = model.new
      @products = current_company.products.all_present(magazine_id)
    end

    # def edit
    #   @sale = find_model
    #   @products = current_company.products.all_present(magazine_id)
    # end

    # def info
    #   @sale = find_model
    # end

    def show
      @transfer = find_model if ((find_model.company_id == current_company.id) rescue true )
      if @transfer.blank?
        redirect_to "/404"
      else
        respond_to do |format|
          format.html
          format.pdf{
            render pdf: "#{@transfer.id}_#{Time.now.to_i}"
          }
        end
      end
    end

    def close
      find_model.close if !find_model.in_stock
      redirect_to "/admin/transfer/#{find_model.id}/edit"
    end

    def create
      transfer = Transfer.create(magazine_id_from: current_magazine.id, magazine_id_to: params[:transfer_param][:magazine_to], company_id: current_company.id)

      create_or_update(transfer)
      redirect_to_index
    end


    def update
      # find_model.close
      find_model.sale_items.destroy_all
      find_model.update(contact_id: params[:contact_id])
      create_or_update(find_model, "update")
      redirect_to_index
    end

    def remove
      # find_model.close
      find_model.destroy
      redirect_to_index
    end

    def paid_out
      @model = find_model
      html_form = render_to_string "/admin/transfers/paid_out", :layout => false, :locals => {:current_company => current_company}
      render plain: @model.company_id == current_company.id ? html_form : "404"
    end

    def def_pay
      transfer = find_model
      transfer.update(paid: true)
      transfer.magazine_from.cashbox.calculation(params[:cashbox_type], transfer.sum, true)
      transfer.magazine_to.cashbox.calculation(params[:cashbox_type], transfer.sum, false)

      render json: {success: true} 
    end

    private

    def create_or_update(transfer)
      trabsfers_arr = params[:buy]
      result = 0
      hash_order = {}
      magazine_to = transfer.magazine_to
      trabsfers_arr.each do |transfer_param|
        count = transfer_param[:count].to_i
        item = ProductItem.find(transfer_param[:item_id])
        price = transfer_param[:price_id].to_i

        result += price * count

        curr_count = hash_order["#{item.id}"].present? ? hash_order["#{item.id}"][:count].to_i + count : count
        hash_order["#{item.id}"] = {count: curr_count, price_id: transfer_param[:price_id].to_i}

        current_item_count = item.product_item_counts.find_by_magazine_id(magazine_id)
        current_count_item_magazine_to = item.product_item_counts.find_by_magazine_id(magazine_to)

        current_item_count.update(count: (current_item_count.count - count) )
        current_count_item_magazine_to.update(count: (current_count_item_magazine_to.count + count))

        TransferItem.create({transfer_id: transfer.id, product_item_id: item.id, count: count, price: price})
      end
      paid = params[:transfer_param][:def_pay] == "1"

      transfer.update(sum: result, visa: (params[:cashbox_type] == "visa"), paid: paid)
      if paid
        current_cashbox.calculation(params[:cashbox_type], result, true)
        magazine_to.cashbox.calculation(params[:cashbox_type], result, false)
      end

    end

    def find_model
      model.find(params[:id])
    end

    def redirect_to_index
      redirect_to '/admin/transfers'
    end

    def params_model
      params.require(:sale).permit(:title).compact rescue {}
    end

    def model
      Transfer
    end

  end
end