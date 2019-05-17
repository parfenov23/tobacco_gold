class Magazine < ActiveRecord::Base
  has_one :cashbox, dependent: :destroy
  belongs_to :company
  has_many :product_item_counts, dependent: :destroy
  has_many :order_requests, dependent: :destroy
  has_many :sales, dependent: :destroy
  after_create :default_create_product_item_count
  after_update :sms_start_ws
  def self.first_url
    "magazins"
  end

  def default_create_product_item_count
    Cashbox.create(magazine_id: id, cash: 0, visa: 0)
    all_ids = ProductItem.where(product_id: Product.where(company_id: company_id).ids).ids
    hash_array = all_ids.map{|id| {product_item_id: id, magazine_id: self.id, count: 0} }
    ProductItemCount.create(hash_array)
  end

  def sms_start_ws
    Thread.list.each{|thread| Thread.kill(thread) if thread[:name] == "sms_start_ws_id_#{id}"}
    if api_key_pushbullet.present?
      Thread.new do
        Thread.current[:name]  = "sms_start_ws_id_#{id}"
        EventMachine.run do
          ws = Faye::WebSocket::Client.new("wss://stream.pushbullet.com/websocket/#{api_key_pushbullet}")
          ws.on :message do |event|
            data_json = JSON.parse(event.data)
            if data_json["type"] == "push" && data_json["push"]["type"] == "sms_changed" && data_json["push"]["source_device_iden"] == api_key_pushbullet_mobile
              sms_notif = data_json["push"]["notifications"].first
              if sms_notif.present?
                correct_json = {"id" => sms_notif["timestamp"].to_s, "body" => sms_notif["body"], "created_at" => sms_notif["timestamp"], "number" => sms_notif["title"]}
                SmsPhone.create_new_sms(id, SmsPhone.params_to_hash_sms(correct_json))
              end
            end
          end
        end
      end
    end
  end

  def today_sales
    sales.where(["created_at > ?", Time.now.beginning_of_day]).where(["created_at < ?", Time.now.end_of_day])
  end
end
