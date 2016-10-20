class VkMessage
  def self.sender(message, type, captcha_arr=[], get_params)
    agent = Mechanize.new
    params_get = params(type).merge({message: message}).merge(get_params)
    params_get.merge!({captcha_sid: captcha_arr.first, captcha_key: captcha_arr.last}) if captcha_arr.present?
    response = JSON.parse(agent.get("https://api.vk.com/method/messages.send", params_get).body)
    if response["error"].present?
      if response["error"]["error_code"] == 14
        code_captcha = anticaptcha(response["error"]["captcha_img"])
        sender(message, type, [response["error"]["captcha_sid"],code_captcha.last], get_params)
      end
    end
  end

  def self.run(message, type="user", get_params={})
    Thread.new { sender(message, type, get_params) }
  end

  def self.params(type)
    case type
    when "user"
      {
        access_token: "9b7dba694b2f38cb8d080c35625e2d7a559b00cd5c73167f782ca02ff07799691a0dbd1fbafbfb686448c",
        chat_id: "53"
      }
    when "group"
      {
        access_token: "d2e5220ce29d44a450ccd93db9c38d95e6860c1e7f0fbbd059cb308eaf59e7668a0b9f798ff647ea71ab2",
      }
    end
  end

  def callback(get_params)
    case get_params[:type]
    when "message_new"
      message_price(get_params[:object])
    end
  end

  def self.message_price(get_params)
    get_params[:object].delete(:date)
    get_params = {type: get_params[:type], object: get_params[:object]}
    unless HistoryVk.where(params_type: get_params.to_s).present?
      body_text = (get_params[:object][:body].mb_chars.downcase.to_s) rescue nil
      if body_text == "прайс"
        message = Product.all.map{|product| "#{product.title}: #{product.current_price} рублей"}.join("\n")
        run(message, type="group", {user_id: get_params[:object][:user_id]})
      elsif body_text.scan("прайс").blank? 
        message = "Новое сообщение в группе\nПользователь: http://vk.com/id#{get_params[:object][:user_id]}\nСообщение: #{body_text}"
        run(message, type="user", {chat_id: '57', title: 'Сообщение в группу'})
      end
      HistoryVk.create(params_type: get_params.to_s)
    end
  end

  def self.anticaptcha(url)
    captcha = Antigate.wrapper('80254ffdc4d2f1fc99f46c92019252f9')
    recognized = captcha.recognize(url, 'jpg')
    recognized
  end
end