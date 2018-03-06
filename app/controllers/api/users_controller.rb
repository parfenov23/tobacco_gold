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
      if params[:password] == params[:password_confirmation]
        user = User.new(email: params[:email])
        user.password = params[:password]
        result = {success: user.save, api_key: user.get_api_key}
      end
      render json: result
    end

    def info
      render json: User.find_by_api_key(params[:user_key]).transfer_to_json
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