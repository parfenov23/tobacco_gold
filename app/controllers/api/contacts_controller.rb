module Api
  class ContactsController < ApiController

    def show
      contact = Contact.where(id: params[:id]).last
      render json: (contact.present? ? contact.transfer_to_json : nil)
    end

    def update
      render json: {success: Contact.find(params[:id]).update(params[:contacts].permit!)}
    end

    def search
      render json: current_company.contacts.search(params[:search]).as_json
    end
  end
end