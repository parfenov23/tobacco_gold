class SessionController < ActionController::Base
  def create
    user = User.where(email: params[:email], role: ["admin", "manager"]).last
    if user.present?
      company = user.magazine.company
      sign_in("user", user) if company.demo_sign_in_time && user.valid_password?(params[:password])
    end
    redirect_index
  end

  def registration
    if params[:password] == params[:confirm_password]
      company = Company.create({title: params[:company], demo_time: (Time.now + 7.day).strftime("%d.%m.%Y")})
      magazine = company.magazines.create({title: params[:company], api_key: SecureRandom.hex})
      user = User.create({email: params[:email], admin: true, role: "admin", magazine_id: magazine.id})
      user.password = params[:password]
      if user.save
        user.get_api_key
        sign_in("user", user)
      else
        company.destroy
        magazine.destroy
      end
    end
    redirect_index
  end

  def redirect_index
    redirect_to (current_user.present? ? "/admin/admin" : "/?error=1")
  end

end
