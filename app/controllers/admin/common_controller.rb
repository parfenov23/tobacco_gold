module Admin
  class CommonController < AdminController
    before_action :current_company

    def index
      @models = model.columns_hash["company_id"].present? ? model.where(company_id: current_company.id) : model.all
    end

    def new
      @model = model.new
      render_if_json
    end

    def create
      create_model = model.create(params_model)
      params[:typeAction] == "json" ? render_json_success(create_model) : redirect_to_index
    end

    def show
      @model = find_model if ((find_model.company_id == current_company.id) rescue true )
    end

    def edit
      @model = find_model
      ((@model.company_id == current_company.id) rescue true ) ? render_if_json : (render text: "Страница не найдена 404")
    end

    def update
      find_model.update(params_model) if ((find_model.company_id == current_company.id) rescue true )
      redirect_to_index
    end

    def remove
      find_model.destroy if ((find_model.company_id == current_company.id) rescue true )
      redirect_to_index
    end

    private

    def redirect_to_index
      redirect_to "/admin/#{model.first_url}"
    end

    def render_if_json
      if params[:typeAction] == "json"
        html_form = render_to_string "/admin/#{@model.class.first_url}/_form", :layout => false, :locals => {:current_company => current_company}
        render text: html_form
      end
    end

    def render_json_success(model=nil)
      render json: {success: true, model: model.to_json}
    end

    def find_model
      begin 
        model.find(params[:id])
      rescue
        redirect_404
      end
    end

    def redirect_404
      redirect_to "/404"
    end

    def params_model
      params.require(model.first_url.to_sym).permit(model.column_names).compact rescue {}
    end

    def current_company
      @current_company = current_user.magazine.company
      @current_company
    end
  end
end