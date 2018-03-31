module Api
  class OrderRequestsController < ApiController

    def create
      params_r = params[:request]
      basket = params[:basket]
      user = User.find(params[:user_id])
      contact = user.contact
      if contact.blank?
        contact_phone = params_r[:user_phone].gsub(/\D/, '')
        contact = Contact.new(first_name: params_r[:user_name], phone: contact_phone)
        contact = contact.save ? contact : Contact.find_by_phone(contact_phone)
        user.update(contact_id: contact.id)
      end
      order = OrderRequest.create(user_id: (user.id rescue nil), user_name: params_r[:user_name], 
        user_phone: params_r[:user_phone], status: "waiting", items: basket, comment: params_r[:comment], company_id: current_company.id)

      order.update(contact_id: contact.id)
      order.notify if Rails.env.production?
      render json: {id: order.id}
    end

    # def show
    #   contact = Contact.where(id: params[:id]).last
    #   render json: (contact.present? ? contact.as_json : nil)
    # end
  end
end