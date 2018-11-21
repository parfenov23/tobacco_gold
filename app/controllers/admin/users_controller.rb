module Admin
  class UsersController < CommonController

    def create
      model.create(params_model.merge(password: params[:users][:password]))
      params[:typeAction] == "json" ? render_json_success : redirect_to_index
    end

    def index
      @models = model.where(magazine_id: current_company.magazines.ids)
      @models = @models.where(role: params[:type]) if params[:type].present? && params[:type] != "all"
      if params[:search].present?
        users_search = @models.where(email: params[:search])
        if users_search.blank?
          users_search = User.where(id: Contact.where(id: @models.ids, phone: params[:search]).ids)
        end
         @models = users_search
      end
    end

    private

    def model
      User
    end
  end
end