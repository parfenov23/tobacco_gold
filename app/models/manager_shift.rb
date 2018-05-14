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
    end    
    manager_shift.save
    manager_shift.notify
  end

  def time
    Rails.env.production? ? (created_at + 5.hour) : created_at
  end

  def notify
    magazine = user.magazine
    message = "Менеджер: #{user.email} #{status == 'open' ? 'открыл' : 'закрыл'} смену\nСумма продаж: #{sum_sales}\nНаличные: #{cash}\nVisa: #{visa}"
    VkMessage.run(message, "user", {access_token: magazine.vk_api_key_user, chat_id: magazine.vk_chat_id}) if (Rails.env.production? && magazine.vk_api_key_user.present?)
  end
end
