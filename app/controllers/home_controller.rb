class HomeController < ActionController::Base
  layout "admin"

  def order_invoice
    @model = OrderRequest.find(params[:id])
    if @model.created_at.to_i != params[:key].to_i
      redirect_to "/404"
    else
      respond_to do |format|
        format.html
        format.pdf{
          render pdf: "#{@model.id}_#{Time.now.to_i}"
        }
      end
    end
  end

  def index
    redirect_to "/admin/admin" if current_user.admin rescue false
  end
end
