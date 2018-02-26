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

  get "how_it_works" => "home#how_it_works"
  get "item" => "home#item"
  get "item/:id" => "home#item"
  get "help" => "home#help"
  get "login" => "home#login"
  get "registration" => "home#registration"
  get "buy_rate" => "home#buy_rate"
  get "bonus" => "home#bonuses"
  get "contacts" => "home#contacts"
  get "all_mixs" => "home#all_mixs"
  get "mix_box/:id" => "home#mix_box"
  get "auth" => "home#auth"
  get "cabinet" => "home#cabinet"
  get "show_sale/:id" => "home#show_sale"

  post "add_item_to_basket" => "home#add_item_to_basket"
  post "rm_item_to_basket" => "home#rm_item_to_basket"
  post "send_item_to_basket" => "home#send_item_to_basket"

  #VK================
  get "callback_vk" => "home#callback_vk"
  post "callback_vk" => "home#callback_vk"
  #===================

  post "profile/update_ava" => "profile#update_ava"
  get "profile" => "profile#edit"
  put "profile" => "profile#update"
  get 'stock' => "admin/stock#index"
  # post "admin/create_attachment" => "admin#create_attachment"

  get '/admin', to: redirect('/admin/admin')

  namespace :admin do
    resources :admin do
      collection do
        get :manager_payments
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
      end
      collection do
        post :search_contact
        get :load_content_product_items
      end
    end

    resources :buy do
      member do
        get :remove
        get :info
        get :def_pay
      end
      collection do
        get :search
        post :search_result
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
    resources :api
    resources :auth do
      collection do
        get :user_info
        get :get_api_key
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
    resources :product_items
    resources :categories do
      member do 
        get :products
      end
    end
    resources :products do
      member do 
        get :product_items
      end
    end
  end

  root :to => "home#index"
end
