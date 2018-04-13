module Admin
  class UsersController < CommonController

    def create
      model.create(params_model.merge(password: params[:users][:password]))
      params[:typeAction] == "json" ? render_json_success : redirect_to_index
    end

    def index
      @models = model.where(magazine_id: current_company.magazines.ids).where(role: ["admin", "manager"])
    end

    private

    def model
      User
    end
  end
end