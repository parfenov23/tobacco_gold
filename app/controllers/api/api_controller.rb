module Api
  class ApiController < ActionController::Base
    require 'vk_message'
    before_action :auth, except: [:find_api_key]


    def index
      render json: {success: true, user_id: current_user.id}
    end

    def company
      render json: current_company.as_json
    end

    def all_magazines
      render json: current_company.magazines.as_json
    end

    def find_api_key
      render json: {api_key: Company.find_by_domain(params[:domain]).magazines.first.api_key}
    end

    def all_content_pages
      render json: ContentPage.where(magazine_id: current_magazine.id).as_json
    end

    def all_top_magazine
      render json: ProductItem.where(id: ProductItemTopMagazine.where(magazine_id: current_magazine.id).ids).transfer_to_json
    end

    def current_price_delivery
      render json: {current_price_delivery: current_magazine.current_price_delivery(params[:current_price].to_f)}
    end

    def auth_domen_vk_group
      VkMessage.message_price(params)
      # binding.pry
      
      # render json: VkMessage.keybord
      render text: params[:return]
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