module Api
  class SmsController < ApiController
    def index
      render json: {success: true}
    end

    def create
      SmsPhone.create_new_sms
      render json: {success: true}
    end

    def pay
      sms = SmsPhone.find(params[:id])
      params_model = {title: sms.clear_body, price: sms.sum, type_mode: (params[:type_mode] == "up" ? true : false), magazine_id: current_user.magazine_id}
      other_buy = OtherBuy.create(params_model)
      current_cashbox.calculation('visa', other_buy.price, other_buy.type_mode)
      # other_buy.notify_buy(current_cashbox)
      sms.update(archive: true)
      redirect_sms
    end

    def info
      render text: "<p>#{SmsPhone.find(params[:id]).body}</p>"
    end

    def current_cashbox
      Cashbox.find_by_magazine_id(current_user.magazine_id)
    end

    def remove
      SmsPhone.find(params[:id]).update(archive: true)
      redirect_sms
    end

    def redirect_sms
      if params[:type] != "json"
        redirect_to "/admin/admin/sms_phone"
      else
        render json: {success: true}
      end
    end
  end
end