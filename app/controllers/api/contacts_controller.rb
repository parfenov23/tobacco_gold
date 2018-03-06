module Api
  class ContactsController < ApiController

    def show
      contact = Contact.where(id: params[:id]).last
      render json: (contact.present? ? contact.as_json : nil)
    end
  end
end