module Api
  class AuthController < ApiController
    before_action :auth, except: [:get_api_key]

    def user_info
      render json: current_user.to_json
    end
    
    def get_api_key
      success = {success: false}
      user = User.find_by_email(params[:email])
      if user.present?
        success = {success: true, api_key: user.get_api_key} if user.valid_password? params[:password]
      end
      render json: success
    end
  end
end