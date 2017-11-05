module Admin
  class UsersController < AdminController
    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      user = User.create(params_user)
      redirect_to "/admin/users/#{user.id}/edit"
    end

    def edit
      @user = find_user
    end

    def update
      find_user.update(params_user)
      redirect_to :back
    end

    def remove
      find_content_page.destroy
      redirect_to :back
    end

    private

    def find_user
      User.find(params[:id])
    end

    def params_user
      params.require(:user).permit(:email, :login, :rate, :password, :role, :procent_sale, :magazine_id).compact.select{|k,v| v != ""}
    end
  end
end