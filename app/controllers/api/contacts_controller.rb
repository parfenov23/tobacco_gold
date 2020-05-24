module Api
  class ContactsController < ApiController

    def show
      contact = Contact.where(id: params[:id]).last
      render json: (contact.present? ? contact.transfer_to_json : nil)
    end

    def update
      contact_params = params[:contacts].permit!
      find_contact = Contact.find(params[:id])
      if contact_params[:password].present?
        user = find_contact.user
        user.password = contact_params[:password]
        user.save
      end
      contact_params.delete(:password)
      render json: {success: find_contact.update(contact_params)}
    end

    def search
      render json: current_company.contacts.search(params[:search]).as_json
    end
  end
end