module Api
  class OrderRequestsController < ApiController

    def create
      params_r = params[:request]
      basket = params[:basket]
      user = User.find(params[:user_id])
      contact = user.contact
      if contact.blank?
        contact_phone = params_r[:user_phone].gsub(/\D/, '')
        contact = Contact.new(first_name: params_r[:user_name], phone: contact_phone, company_id: current_company.id)
        contact = contact.save ? contact : Contact.find_by_phone(contact_phone)
        user.update(contact_id: contact.id)
      end
      address = "г.#{params_r[:address][:city]} ул.#{params_r[:address][:street]} д.#{params_r[:address][:house]} кв.#{params_r[:address][:room]}, подьезд: #{params_r[:address][:porch]}, этаж: #{params_r[:address][:floor]}, домофон: #{params_r[:address][:domofon]}"
      comment = params_r[:surrender].present? ? "Нужна сдача с #{params_r[:surrender]}. #{params_r[:comment]}" : params_r[:comment]
      order = OrderRequest.create(user_id: (user.id rescue nil), user_name: params_r[:user_name], 
        user_phone: params_r[:user_phone], status: "waiting", items: basket, comment: comment, 
        company_id: current_company.id, magazine_id: current_magazine.id, address: address, type_payment: params_r[:type_payment])

      order.update(contact_id: contact.id)
      order.notify if Rails.env.production?
      
      render json: {id: order.id}
    end

    def contact_order_request
      render json: OrderRequest.where(contact_id: params[:contact_id]).map(&:transfer_to_json)
    end

    # def show
    #   contact = Contact.where(id: params[:id]).last
    #   render json: (contact.present? ? contact.as_json : nil)
    # end
  end
end