class VkMessage
  def self.sender(message, type, captcha_arr=[], get_params)
    agent = Mechanize.new
    random_id = Time.now.to_i
    params_get = params(type).merge({message: message, v: '5.92', random_id: random_id}).merge(get_params)
    params_get.merge!({captcha_sid: captcha_arr.first, captcha_key: captcha_arr.last}) if captcha_arr.present?
    response = JSON.parse(agent.post("https://api.vk.com/method/messages.send", params_get).body)
    # binding.pry
    return_status = {status: true, code: "ok"}
    if response["error"].present?
      if response["error"]["error_code"] == 14
        code_captcha = anticaptcha(response["error"]["captcha_img"])
        sender(message, type, [response["error"]["captcha_sid"], code_captcha], get_params)
      else
        return_status = {status: false, code: response["error"]["error_code"]}
      end
    end
    return return_status
  end

  def self.run(message, type="user", get_params={})
    Thread.new { sender(message, type, get_params) }
  end

  def self.params(type)
    case type
    when "user"
      {
        # access_token: "6752b799a52769e374f51deb9e549b75a0bfdebcd18a06b6e8669a2bea5899e2db697eb54a12aef5e4b2e",
        chat_id: "1"
      }
    when "group"
      {
        access_token: "de9bf6eedc4ff2e22ae8dfadaa4693904a51344ecb15c6702a2b9d03e6896acf202994487ffbd727f1077",
      }
    when "user_bot"
      {
        access_token: "0f9e712a6c26480f9d1580742ae6dd7a147a58243e1bf5053c34f876ad4f43d43982cc6195bd9ecfb7ed3",
      }
    end
  end

  def callback(get_params)
    case get_params[:type]
    when "message_new"
      message_price(get_params[:object])
    end
  end

  def self.all_users_dialog_group
    agent = Mechanize.new
    response = JSON.parse(agent.get("https://api.vk.com/method/messages.getDialogs", params("group").merge({count: 200})).body)
    arr = response["response"].drop(1)
    user_ids = arr.map{|a| a["uid"]}
    JSON.parse(agent.get("https://api.vk.com/method/users.get", 
      params("user").merge({user_ids: user_ids.join(","), fields: "can_write_private_message"})).body)["response"].map{|user| user["uid"] if user["can_write_private_message"] == 1}.compact
  end

  def self.message_price(get_params)
    if get_params[:object].present?
      get_params[:object].delete(:date)
      get_params = {type: get_params[:type], object: get_params[:object], api_key: get_params[:api_key]}
      magazine = Magazine.find_by_api_key(get_params[:api_key])
      company = magazine.company
      unless HistoryVk.where(params_type: get_params.to_s).present?
        body_text = (get_params[:object][:text].mb_chars.downcase.to_s) rescue nil
        if body_text == "прайс"
          message = company.products.all_present(magazine.id).map{|product| 
            "#{product.title}: #{product.current_price} рублей"
          }.join("\n")
          run(message, type="group", {user_id: get_params[:object][:peer_id], access_token: magazine.vk_api_key_group})
        elsif body_text == "акция"
          message = magazine.special_offer
          run(message, type="group", {user_id: get_params[:object][:peer_id], access_token: magazine.vk_api_key_group})
        # else
        #   sender("Вот ваши кнопки", type="group", {peer_id: get_params[:object][:peer_id], keybord: keybord.as_json})
        end
        HistoryVk.create(params_type: get_params.to_s)
      end
    end
  end

  def self.keybord
    {"one_time"=>false, "buttons"=>[[{"action"=>{"type"=>"text", "payload"=>"{\"button\": \"1\"}", "label"=>"Red"}, "color"=>"negative"}, {"action"=>{"type"=>"text", "payload"=>"{\"button\": \"2\"}", "label"=>"Green"}, "color"=>"positive"}], [{"action"=>{"type"=>"text", "payload"=>"{\"button\": \"3\"}", "label"=>"White"}, "color"=>"default"}, {"action"=>{"type"=>"text", "payload"=>"{\"button\": \"4\"}", "label"=>"Blue"}, "color"=>"primary"}]]} 
  end

  def self.anticaptcha(url)
    client = AntiCaptcha.new("b12c3120278775a969d7a4d57c5bf3bf")
    result = client.decode_image!(body64: Base64.encode64(open(url).read) )
    result.api_response["solution"]["text"]
  end
end