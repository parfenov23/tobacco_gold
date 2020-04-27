module Admin
  class ContentPagesController < CommonController

    def index
      @models = model.where(magazine_id: current_magazine.id)
    end
    
    private
    
    def model
      ContentPage
    end
  end
end