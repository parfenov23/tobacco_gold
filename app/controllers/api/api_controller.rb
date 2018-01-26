module Api
  class ApiController < ActionController::Base
    before_action :auth

    def index
      render json: {success: true}
    end

    def current_cashbox
      @current_magazine.present? ? Cashbox.find_by_magazine_id(@current_magazine.id) : nil
    end

    def auth
      @current_magazine = Magazine.find_by_api_key(params[:api_key])
      render json: {auth: false} if @current_magazine.blank?
    end
  end
end