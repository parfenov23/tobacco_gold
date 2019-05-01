class SmsGateway
  def self.messages(type="all", status="", number="")
    agent = Mechanize.new
    url = "http://smsgateway.me/api/v3/messages"
    json = JSON.parse(agent.get(url, param_auth).body)
    result_sms = []
    if type == "all"
      result_sms = json["result"]
    else
      json["result"].each do |result|
        result_sms << result if result["status"] == status && result["contact"]["number"] == number
      end
    end
    result_sms
  end

  def self.param_auth
    {email: "parfenov407@gmail.com", password: "lolopo123"}
  end

  def self.send_request(api_key, url, body = "", type="get")
    uri = URI.parse(url)
    request = type == "get" ? Net::HTTP::Get.new(uri) : Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Access-Token"] = api_key
    request.body = body

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.body
  end
end