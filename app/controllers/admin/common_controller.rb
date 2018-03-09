module Admin
  class CommonController < AdminController
    def index
      @models = model.columns_hash["company_id"].present? ? model.where(company_id: current_company.id) : model.all
    end

    def new
      @model = model.new
      render_if_json
    end

    def create
      model.create(params_model)
      params[:typeAction] == "json" ? render_json_success : redirect_to_index
    end

    def show
      @model = find_model
    end

    def edit
      @model = find_model
      render_if_json
    end

    def update
      find_model.update(params_model)
      redirect_to_index
    end

    def remove
      find_model.destroy
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

    def render_json_success
      render json: {success: true}
    end

    def find_model
      model.find(params[:id])
    end

    def params_model
      params.require(model.first_url.to_sym).permit(model.column_names).compact.select { |k, v| v != "" } rescue {}
    end

    def current_company
      @current_company = current_user.magazine.company
      @current_company
    end
  end
end