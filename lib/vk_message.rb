class VkMessage
  def self.sender(message, captcha_arr=[])
    agent = Mechanize.new
    params_get = params.merge({message: message})
    params_get.merge!({captcha_sid: captcha_arr.first, captcha_key: captcha_arr.last}) if captcha_arr.present?
    response = JSON.parse(agent.get("https://api.vk.com/method/messages.send", params_get).body)
    if response["error"].present?
      if response["error"]["error_code"] == 14
        code_captcha = anticaptcha(response["error"]["captcha_img"])
        sender(message, code_captcha)
      end
    end
  end

  def self.run(message)
    Thread.new { sender(message) }
  end

  def self.params
    {
      access_token: "9b7dba694b2f38cb8d080c35625e2d7a559b00cd5c73167f782ca02ff07799691a0dbd1fbafbfb686448c",
      chat_id: "53"
    }
  end

  def self.anticaptcha(url)
    captcha = Antigate.wrapper('c83da0e4119a0dbd55c9d69ee72f62cc')
    recognized = captcha.recognize(url, 'jpg')
    recognized
  end
end