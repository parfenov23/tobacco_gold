module Admin
  class ContactsController < AdminController
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

    def show
      @model = find_model
    end

    def edit
      @model = find_model
    end

    def update
      find_model.update(params_model)
      redirect_to_index
    end

    def sms_send
      all_phones = model.all.map(&:phone)
      sms = Smsc::Sms.new('tobaccogold', 'lolopo123', 'utf-8') 
      sms.message(params[:description], all_phones, sender: "tobacco_gold")

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

    def redirect_to_index
      redirect_to "/admin/#{model.first_url}"
    end

    def find_model
      model.find(params[:id])
    end

    def params_model
      params.require(model.to_s.downcase.to_sym).permit(model.column_names).compact.select { |k, v| v != "" } rescue {}
    end
  end
end