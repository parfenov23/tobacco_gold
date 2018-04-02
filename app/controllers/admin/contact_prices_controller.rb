module Admin
  class ContactPricesController < CommonController

    def index
      contact = current_company.contacts.where(id: params[:contact_id]).last
      contact.present? ? (@models = contact.contact_prices) : redirect_404
    end

    def remove
      contact_id = find_model.contact_id
      find_model.destroy if ((find_model.company_id == current_company.id) rescue true )
      redirect_to "/admin/#{model.first_url}?contact_id=#{contact_id}"
    end

    private

    def model
      ContactPrice
    end

    def redirect_to_index
      redirect_to "/admin/#{model.first_url}?contact_id=#{params[:contact_prices][:contact_id]}"
    end
  end
end