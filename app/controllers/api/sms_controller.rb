module Api
  class SmsController < ApiController
    def index
      render json: {success: true}
    end

    def create
      SmsPhone.create_new_sms(current_magazine.id)
      render json: {success: true}
    end

    def pay
      sms = SmsPhone.find(params[:id])
      sms.pay_to_other_by(params[:type_mode])
      render json: {success: true}
    end

    def info
      render text: "<p>#{SmsPhone.find(params[:id]).body}</p>"
    end

    def remove
      SmsPhone.find(params[:id]).update(archive: true)
      render json: {success: true}
    end
  end
end