module Api
  class ApiController < ActionController::Base
    before_action :auth

    def index
      render json: {success: true, user_id: current_user.id}
    end

    def company
      render json: current_company.as_json
    end

    def all_magazines
      render json: current_company.magazines.as_json
    end

    private

    def auth
      auth_key = params[:api_key].to_s.gsub("?", "").gsub(/(task=send|task=sent|task=result)/, '')
      if auth_key.present?
        @current_user = User.first
        @current_magazine = Magazine.find_by_api_key(auth_key)
      end
      render json: {auth: false, code: '401'} if @current_user.blank?
    end

    def current_user
      @current_user
    end

    def current_magazine
      @current_magazine
    end

    def current_company
      current_magazine.company
    end

    def current_cashbox
      current_magazine.present? ? Cashbox.find_by_magazine_id(current_magazine.id) : nil
    end
  end
end