class YandexKassa
  require 'net/http'
  require 'uri'
  require 'json'

  def self.create_payment(amount, title, order_payment_id)
    body = {
      amount:{
        value: amount,
        currency: "RUB"
      },
      capture: true,
      metadata: {order_payment_id: order_payment_id},
      confirmation: {
        type: "redirect",
        return_url: auth[:return_url]
      },
      descriptio: title
    }
    request("post", "https://payment.yandex.net/api/v3/payments", body)
  end

  def self.info_payment(id)
    request("get", "https://payment.yandex.net/api/v3/payments/#{id}", {})
  end

  def self.request(type, url, body)
    uri = URI.parse(url)
    request = type == "post" ? Net::HTTP::Post.new(uri) : Net::HTTP::Get.new(uri)
    request.basic_auth(auth[:id], auth[:api])
    request.content_type = "application/json"
    request["Idempotence-Key"] = SecureRandom.hex(8)
    request.body = JSON.dump(body)
    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    JSON.parse response.body
  end

  def self.auth
    if Rails.env.production? 
      {id: "736297", api: "live_u43V-b3D1BATgBYLRSBBYrdHsqiUSrvlbNfmzdg_dQM", return_url: "https://crm-stock.ru/admin/order_payments"}
    else
      {id: "740395", api: "test_u7WFVMCw0NwfGZwG4plflNKCKiAjflHiU6v49X6XOlU", return_url: "http://localhost:3000/admin/order_payments"}
    end
  end

end