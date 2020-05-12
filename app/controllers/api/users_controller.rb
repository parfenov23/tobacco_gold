module Api
  class UsersController < ApiController
    def index
      render json: {success: true}
    end

    def auth_user
      user = User.where(email: params[:login]).last
      result = (user.present? && user.valid_password?(params[:password])) ? {success: true, api_key: user.get_api_key} : {success: false}
      render json: result
    end

    def reg_user
      result = {success: false}
      user_params = params[:user]
      contact_params = params[:contact]
      if user_params[:password] == user_params[:password_confirmation]
        user = User.find_or_create_by(email: user_params[:email], magazine_id: current_magazine.id)
        user.password = user_params[:password]
        result = {success: user.save, api_key: user.get_api_key}
        if result[:success]
          user.update(contact_id: Contact.find_or_create_by(first_name: contact_params[:first_name], phone: contact_params[:phone], company_id: current_company.id).id )
        end
      end
      render json: result
    end

    def info
      user = User.where(api_key: params[:user_key]).last
      render json: user.present? ? user.transfer_to_json : {}
    end

    def auth_admin
      resource = User.where(api_key: params[:api_key], role: ["admin", "manager"]).last
      if resource.present?
        sign_in("user", resource)
        redirect_to "/admin/admin"
      else
        redirect_to "/"
      end
    end

  end
end