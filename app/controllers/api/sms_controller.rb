module Api
  class SmsController < ApiController
    def index
      render json: {success: true}
    end

    def create
      sms_phone = SmsPhone.where(address: params["address"], body: params["body"]).last
      if sms_phone.blank?
        SmsPhone.create(address: params["address"], body: params["body"], date_time: Time.now.to_i.to_s)
        regexp = Regexp.new(/(списание|покупка) [0-9]+р/)
        sum = params["body"].match(regexp).to_s.gsub(/(списание|покупка|) /, '').gsub("р", "").to_i
        if sum > 0
          OtherBuy.create(title: params["body"], price: sum, magazine_id: @current_magazine.id, processed: false)
        end
      end
      render json: {success: true}
    end
    
    def import
      JSON.parse(params[:allSms]).each do |sms|
        if sms["address"] == "900"
          sms_phone = SmsPhone.find_or_create_by(address: sms["address"], body: sms["body"])
          sms_phone.update(date_time: sms["date"])
        end
      end
      render json: {success: true}
    end
  end
end