module Admin
  class ContentPagesController < AdminController
    def index
      @all_content_page = ContentPage.all
    end

    def new
      @content_page = ContentPage.new
    end

    def create
      content_page = ContentPage.where(name_page: params_content[:name_page]).last
      unless content_page.present?
        content_page = ContentPage.create(params_content)
      else
        content_page.update(params_content)
      end
      redirect_to "/admin/content_pages/#{content_page.id}/edit"
    end

    def edit
      @content_page = find_content_page
    end

    def update
      content_page = ContentPage.where(name_page: params_content[:name_page]).last
      unless content_page.present?
        ContentPage.create(params_content)
      else
        content_page.update(params_content)
      end
      redirect_to :back
    end

    def remove
      find_content_page.destroy
      redirect_to :back
    end

    private

    def find_content_page
      ContentPage.find(params[:id])
    end

    def params_content
      params.require(:content).permit(:name_page, :description, :title)
    end
  end
end