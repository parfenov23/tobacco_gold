module Superuser
  class CompanyController < CommonController

    def update
      find_model.update(params_model)
      setting_nav = params[:setting_nav].map{|k,v| k if v == "1"}.compact.join(",")
      find_model.update(setting_nav: setting_nav) if setting_nav.present?
      params[:typeAction] == "json" ? render_json_success(find_model) : redirect_to_index
    end

    private

    def model
      Company
    end
  end
end