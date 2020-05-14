class OrderRequestMail < ApplicationMailer
  default from: "support@crm-stock.ru"

  def sample_email(order, send_email)
    @order = order
    mail(to: send_email, subject: "Новый заказ №#{@order.id}")
  end
end
