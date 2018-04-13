module Admin
  class UsersController < CommonController

    def index
      @models = model.where(magazine_id: current_company.magazines.ids).where(role: ["admin", "manager"])
    end

    private

    def model
      User
    end
  end
end