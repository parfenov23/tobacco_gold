module Api
  class ApiController < ActionController::Base
    before_action :auth

    def index
      render json: {success: true}
    end

    def auth
      @current_magazine = Magazine.find_by_api_key(params[:api_key])
      render json: {auth: false} if @current_magazine.blank?
    end
  end
end