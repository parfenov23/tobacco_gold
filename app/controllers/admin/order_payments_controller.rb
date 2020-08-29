module Admin
  class OrderPaymentsController < CommonController
    require 'yandex_kassa'

    def create
      find_tarif = OrderPayment.find_tariff(params[:tariff])
      count_month = params[:count_month].to_i
      amount = find_tarif[:amount] * count_month
      amount = find_tarif[:pay_year] * count_month if count_month == 12 && find_tarif[:pay_year].to_i > 0
      order_payment = model.create({tariff: find_tarif[:key], amount: amount, payment: false, company_id: current_company.id, month: count_month})
      yk = YandexKassa.create_payment(amount, "Оплата тарифа: #{find_tarif[:title]}", order_payment.id)
      order_payment.update(payment_id: yk["id"], params: yk.to_json)
      render json: {success: true, redirect_url: yk["confirmation"]["confirmation_url"]}
    end

    def model
      OrderPayment
    end
  end
end
