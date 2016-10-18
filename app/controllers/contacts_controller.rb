class ContactsController < ApplicationController

  def index
    @models = model.all
  end

  def new
    @model = model.new
  end

  def create
    model.create(params_model)
    redirect_to_index
  end

  def edit
    @model = find_model
  end

  def show
    @model = find_model
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

  def model
    Contact
  end

  def find_model
    model.find(params[:id])
  end

  def redirect_to_index
    redirect_to '/contacts'
  end

  def params_model
    params.require(:contacts).permit(:first_name, :phone, :social).compact rescue {}
  end
end
