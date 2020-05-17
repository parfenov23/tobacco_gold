module Api
  class UsersController < ApiController
    def index
      render json: {success: true}
    end

    def auth_user
      user = User.where(email: params[:login]).last
      result = if user.blank?
        {success: false, text_error: "Пользователь с таким Email не зарегистрирован"}
      elsif !user.valid_password?(params[:password])
        {success: false, text_error: "Не верный пароль"}
      else
        {success: true, api_key: user.get_api_key}
      end
      render json: result
    end

    def reg_user
      result = {success: false}
      user_params = params[:user]
      contact_params = params[:contact]
      if user_params[:password] == user_params[:password_confirmation]
        params_user = {email: user_params[:email], magazine_id: current_magazine.id}
        user = User.where(params_user).last
        if user.blank?
          user = User.create(params_user)
          user.password = user_params[:password]
          result[:text_error] = "Пароль должен содержать минимум 6 символов" if user_params[:password].length < 6
          result.merge!({success: user.save, api_key: user.get_api_key})
          if result[:success]
            user.update(contact_id: Contact.find_or_create_by(first_name: contact_params[:first_name], phone: contact_params[:phone], company_id: current_company.id).id )
          end
        else
          result[:text_error] = "Такой Email уже зарегистрирован"
        end
      end
      render json: result
    end

    def info
      user = User.where(api_key: params[:user_key]).last
      render json: user.present? ? user.transfer_to_json : {}
    end

    def auth_admin
      resource = User.where(api_key: params[:api_key], role: ["admin", "manager"]).last
      if resource.present?
        sign_in("user", resource)
        redirect_to "/admin/admin"
      else
        redirect_to "/"
      end
    end

    def reset_password
      user = User.where(email: params[:email]).last
      if user.present?
        pass = SecureRandom.hex(8)
        user.password = pass
        user.save
        OrderRequestMail.user_reset_password(pass, user.magazine.company.domain ,user.email).deliver_now
        text_error = "Новый пароль отправлен на ваш Email!"
      else
        text_error = "Пользователь с таким Email не найден!"
      end
      render json: {success: true, text: text_error}
    end

  end
end