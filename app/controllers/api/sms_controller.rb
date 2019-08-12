module Api
  class SmsController < ApiController
    before_action :auth, except: [:create]
    def index
      all_messages = SmsPhoneTask.where(magazine_id: current_magazine.id, status: false)
      all_messages_arr = all_messages.map{|spt|
        {to: spt.phone, message: spt.body, uuid: spt.sms_id}
      }
      json = {
        payload: {
          task: "send",
          secret: "",
          messages: all_messages_arr
        }
      }
      p json
      all_messages.update_all(status: true)
      render json: json
    end

    def create
      SmsPhone.create_new_sms(SmsPhone.params_to_hash_sms(correct_json))
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

    def params_task
      curr_api = params[:api_key].to_s.gsub("?", "").gsub(/(task=send|task=sent|task=result)/, '')
      params[:api_key].gsub(curr_api, '').gsub("?task=", '')
    end

    def remove
      SmsPhone.find(params[:id]).update(archive: true)
      render json: {success: true}
    end

    def correct_json
      {
        "id" => params["timestamp"].to_s, 
        "body" => params["message"], 
        "created_at" => params["timestamp"], 
        "number" => params["from"],
        "mobile_phone" => params["phone_number"]
      }
    end

    # def self.sms_start_ws
    #   Magazine.where.not(api_key_pushbullet: nil).each do |magazine|
    #     magazine.sms_start_ws
    #   end
    # end

  end
end