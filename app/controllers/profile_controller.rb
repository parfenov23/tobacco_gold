require 'base64'
require 'resize_image'
class ProfileController < ActionController::Base
  before_filter :find_resource
  layout "home"
  before_filter :authenticate_user!, only: [:update, :edit]

  def update_ava
    unless params[:ava].nil?
      img = ResizeImage.crop(params[:ava].path)
      img_base64 = Base64.encode64(File.open(img.path, "rb").read)
      current_user.update(avatar: img_base64)
      render json: {base64: img_base64}
    else
      render json: {error: "You do not pass the picture"}
    end
  end

  def update
    @resource.email = params_user[:email]
    @resource.login = params_user[:login]
    @resource.password = params_user[:password] if !current_user.valid_password?(params_user[:password])
    @resource.save(validate: false)

    redirect_to "/users/edit"
  end

  def find_resource
    @resource = current_user
  end

  private

  def params_user
    params.require(:user).permit(:email, :login, :password_confirmation, :password, :current_password)
  end
end