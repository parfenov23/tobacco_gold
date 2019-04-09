require 'vk_message'
class ManagerShift < ActiveRecord::Base
  belongs_to :user

  def self.current_day
    self.where(["created_at > ?", Time.now.beginning_of_day])
  end

  def self.open_or_close(user, params)
    manager_shift = new params
    current_day_close = user.manager_shifts.current_day.where(status: "close")
    if manager_shift.status == "close" && current_day_close.blank?
      user.manager_payments.create({price: user.sum_shift, magazine_id: user.magazine_id})
      if user.balance_payments > 0 && user.phone.present? && user.auto_payment
        SmsPhoneTask.create(phone: "900", body: "ПЕРЕВОД #{user.phone} #{user.balance_payments}", magazine_id: user.magazine_id, sms_id: Time.now.to_i.to_s)
        user.manager_payment_cash('visa') if user.magazine.cashbox.visa >= user.balance_payments
      end
    end    
    manager_shift.save
    manager_shift.notify
  end

  def time
    Rails.env.production? ? (created_at + 5.hour) : created_at
  end

  def notify
    magazine = user.magazine
    sale_today = magazine.today_sales
    sale_today_visa = sale_today.where(visa: true).sum(:price)
    sale_today_cash = sale_today.where(visa: false).sum(:price)
    message = "Менеджер: #{user.email} #{status == 'open' ? 'открыл' : 'закрыл'} смену\n
    ---- Информация по продажам ----
    Общая сумма продаж: #{sum_sales}
    Наличные: #{sale_today_cash} | Visa: #{sale_today_visa}\n
    ---- Касса ----
    Наличные: #{cash} | Должно быть: #{magazine.cashbox.cash}
    Visa: #{visa}"
    VkMessage.run(message, "user", {access_token: magazine.vk_api_key_user, chat_id: magazine.vk_chat_id}) if (Rails.env.production? && magazine.vk_api_key_user.present?)
  end
end
