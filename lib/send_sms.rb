class SendSms
  def self.sender(phones, description)
    if Rails.env.production?
      sms = Smsc::Sms.new('tobaccogold', 'lolopo123', 'utf-8') 
      sms.message(description, phones, sender: "crm-stock")
    end
  end
end