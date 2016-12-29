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
  get "help" => "home#help"
  get "login" => "home#login"
  get "registration" => "home#registration"
  get "buy_rate" => "home#buy_rate"
  get "bonus" => "home#bonuses"
  get "contacts" => "home#contacts"
  get "auth" => "home#auth"

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
    end

    resources :revision

    resources :cashbox

    resources :sales do
      member do
        get :remove
        get :info
      end
    end

    resources :buy do
      member do
        get :remove
        get :info
      end
      collection do
        post :new_item_product
      end
    end

    resources :other_buy do
      member do
        get :remove
      end
    end
  end

  root :to => "home#index"
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
