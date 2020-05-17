class OrderRequestMail < ApplicationMailer
  default from: "support@crm-stock.ru"

  def sample_email(order, send_email)
    @order = order
    mail(to: send_email, subject: "Новый заказ №#{@order.id}")
  end

  def user_reset_password(pass, url, send_email)
    @pass = pass
    @url = url
    @send_email = send_email
    mail(to: send_email, subject: "Восстановление пароля")
  end
end
