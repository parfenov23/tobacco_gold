Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # resources :contacts do
  #   member do
  #     get :remove
  #   end
  # end

  # get 'auth' => 'home#auth'
  # get 'test_pay' => 'home#test_pay'
  # post 'auth_user' => 'home#auth_user'
  # # You can have the root of your site routed with "root"
  # root 'products#index'
  devise_for :users

  get '/admin', to: redirect('/admin/admin')
  get 'order_invoice/:id' => "home#order_invoice"
  
  resources :session do
    collection do
      post :registration
    end
  end

  namespace :admin do
    resources :admin do
      collection do
        get :manager_payments
        get :shift_manager
        post :create_shift_manager
        get :paid_manager_payments
        get :search
        get :api_sms
        get :sms_phone
        get :sms_phone_to_other_by
        get :sms_phone_remove
      end
    end
    resources :categories do
      member do
        get :remove
      end
    end
    resources :contact_prices do
      member do
        get :remove
      end
    end
    resources :hookah_cash do
      member do
        get :remove
      end
    end
    resources :items do
      member do
        get :remove
      end
    end
    resources :questions do
      member do
        get :remove
      end
    end

    resources :order_requests do
      member do
        get :remove
        get :reserve
      end
    end

    resources :mix_boxes do
      member do
        get :remove
      end
    end

    resources :mix_box_items do
      member do
        get :remove
      end
    end

    resources :providers do
      member do
        get :remove
      end
    end

    resources :provider_items do
      member do
        get :remove
      end
    end

    # resources :attachments do
    #   member do
    #     get :remove
    #   end
    # end

    resources :content_pages do
      member do
        get :remove
      end
    end
    resources :users do
      member do
        get :remove
      end
    end
    resources :magazins do
      member do
        get :remove
      end
    end


    resources :contacts do
      member do
        get :remove
      end
      collection do 
        get :sms
        get :table
        post :sms_send
        get :vk
        post :vk_send
        get :dispatch_vk
        post :dispatch_vk_send
      end
    end

    resources :products do
      member do
        get :remove
      end
    end

    resources :product_items do
      member do
        get :remove
      end
    end

    resources :tags do
      member do
        get :remove
      end
      collection do
        get :search
        post :remove_product_item
      end
    end

    resources :product_prices do
      member do
        get :remove
      end
    end

    resources :stock do
      collection do
        get :to_excel
      end
      member do 
        get :info
      end
    end

    resources :revision

    resources :cashbox do
      collection do
        get :to_check
        post :update_cashbox
        get :api
      end
    end

    resources :sales do
      member do
        get :remove
        get :info
        get :close
      end
      collection do
        post :search_contact
        post :save_order_request
        get :load_content_product_items
      end
    end

    resources :transfers do
      member do
        get :remove
        get :info
        get :close
        post :def_pay
        get :paid_out
      end
      collection do
        get :load_content_product_items
      end
    end

    resources :buy do
      member do
        get :remove
        get :info
        post :def_pay
        get :paid_out
      end
      collection do
        get :search
        post :search_result
        post :search_result_update
        post :form_search_result
        post :new_item_product
      end
    end

    resources :other_buy do
      member do
        get :remove
      end
    end
  end

  # Api Routes
  namespace :api do
    resources :api do
      collection do
        get :company
        post :company
        post :auth_domen_vk_group
        get :all_magazines
        get :all_content_pages
        get :all_top_magazine
        get :find_api_key
      end
    end
    resources :auth do
      collection do
        get :user_info
        get :get_api_key
      end
    end

    resources :users do
      collection do
        get :auth_user
        get :auth_admin
        get :reg_user
        get :info
      end
    end
    resources :contacts do
      collection do
        get :search
      end
    end

    resources :sms do
      collection do
        post :import
      end
      member do
        get :remove
        get :pay
        get :info
      end
    end

    resources :cashbox
    resources :order_requests
    resources :product_items do
      collection do
        get :search
        get :get_search
        post :load
      end
    end
    resources :categories do
      member do 
        get :products
      end
    end
    resources :sales do
      collection do
        get :all_contact
      end
      member do 
        get :sale_items
      end
    end
    resources :products do
      collection do
        post :prices
      end
      member do 
        get :product_items
      end
    end
  end

  root :to => "home#index"
end
