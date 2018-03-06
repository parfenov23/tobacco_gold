module Api
  class SalesController < ApiController

    def all_contact
      sales = Sale.where(contact_id: params[:contact_id])
      render json: sales.as_json
    end

    def sale_items
      sale_items = SaleItem.where(sale_id: params[:id])
      render json: sale_items.map(&:transfer_to_json)
    end
  end
end