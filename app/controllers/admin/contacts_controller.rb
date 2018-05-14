module Admin
  require 'send_sms'
  class ContactsController < CommonController
    def create
      params_r = params_model
      params_r[:phone] = params_r[:phone].gsub(/\D/, '')
      email = params[:contacts][:email]
      if email.present? && User.find_by_email(email).blank?
        contact = model.create(params_r)

        pass = SecureRandom.hex(3)
        user = User.create(email: email, contact_id: contact.id, magazine_id: current_company.magazines.first.id)
        user.password = SecureRandom.hex(3)
        user.save

        SendSms.sender([params_r[:phone]], "Логин: #{email}\nПароль: #{pass}\n#{request.base_url}") if Rails.env.production?
      end
      redirect_to_index
    end

    private

    def model
      Contact
    end
  end
end