module Api
  class ApiController < ActionController::Base
    before_action :auth

    def index
      render json: {success: true, user_id: current_user.id}
    end

    private

    def auth
      if params[:api_key].present?
        @current_user = User.find_by_api_key(params[:api_key])
        @current_magazine = @current_user.magazine if @current_user.present?
      end
      render json: {auth: false, code: '401'} if @current_user.blank?
    end

    def current_user
      @current_user
    end

    def current_magazine
      @current_magazine
    end

    def current_cashbox
      current_magazine.present? ? Cashbox.find_by_magazine_id(current_magazine.id) : nil
    end
  end
end