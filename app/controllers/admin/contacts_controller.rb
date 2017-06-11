module Admin
  class ContactsController < AdminController
    require 'vk_message'

    def index
      @models = model.all
    end

    def new
      @model = model.new
    end

    def create
      params_r = params_model
      params_r[:phone] = params_r[:phone].gsub(/\D/, '')
      model.create(params_r)
      redirect_to_index
    end

    def show
      @model = find_model
    end

    def edit
      @model = find_model
    end

    def update
      params_r = params_model
      params_r[:phone] = params_r[:phone].gsub(/\D/, '')
      find_model.update(params_r)
      redirect_to_index
    end

    def sms_send
      all_phones = model.all.map(&:phone)
      sms = Smsc::Sms.new('tobaccogold', 'lolopo123', 'utf-8') 
      sms.message(params[:description], all_phones, sender: "TobaccoGold")

      redirect_to_index
    end

    def vk_send
      Thread.new {
        VkMessage.all_users_dialog_group.each do |uid|
          sleep(3)
          VkMessage.sender(params[:description], type="group", {user_id: uid})
        end
      }
      redirect_to_index
    end

    def dispatch_vk_send
      Thread.new {
        accounts = params[:accounts].split(",")
        user_accounts = params[:user_accounts].split(",")
        c_acc = 0
        user_accounts.each do |user|
          curr_acc = accounts[c_acc]
          if VkUser.find_by_domain(user).blank?
            status = VkMessage.sender(params[:description], "user_bot", {domain: user.gsub("/", ""), access_token: curr_acc, attachment: params[:attachment]})
            if status[:status]
              VkUser.create(domain: user)
              sleep(120)
            else
              if status[:code] != 7
                c_acc += 1
                break if c_acc == accounts.count
              end
            end
          end
        end
      }
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