class HookahCash < ActiveRecord::Base
  def notify_buy
    message = "#{title} на #{price.to_i} рублей\nКасса кальянов: #{HookahCash.cash_box} рублей"
    VkMessage.run(message)
  end

  def self.cash_box
    HookahCash.all.where(type_mode: true).sum(:price) - HookahCash.all.where(type_mode: false).sum(:price)
  end
end
