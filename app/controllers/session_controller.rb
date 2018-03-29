class SessionController < ActionController::Base
  def create
    user = User.where(email: params[:email], role: ["admin", "manager"]).last
    sign_in("user", user) if user.present? && user.valid_password?(params[:password])
    redirect_index
  end

  def registration
    if params[:password] == params[:confirm_password]
      company = Company.create({title: params[:company]})
      magazine = Magazine.create({title: params[:company], company_id: company.id})
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
