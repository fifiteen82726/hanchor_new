Rails.application.routes.draw do
  root to: 'welcome#index'
  get 'aboutus' => 'welcome#aboutus'
  get 'shopping_guide' => "welcome#shopping_guide"
  get 'faq' => 'welcome#faq'
  get 'contact' => 'welcome#contact'

  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get  "/auth/:provider/callback" => "sessions#login_by_auth", as: "login_by_auth"
  post '/auth/:provider', to: lambda{|env| [404, {}, ["Not Found"]]}, as: 'auth'

  get 'set_currency', to: 'sessions#set_currency'

  resources :payment_notifications, only: [:create] do
    collection do
      post :allpay
    end
  end

  resources :users, only: [:create,:update]

  resources :news

  get 'products/quantity' => "products#quantity"
  get 'products/:category' => "products#index", as: "products_index"
  get 'products/:category/:id' => "products#show", as: "products_show"


  get 'account' => "account#index"
  get 'account/edit' => "account#edit"
  get 'account/orders' => "account#orders"

  resources :paid_notify, only: [:create]
  
  get '/forget_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get '/confirm_password_reset', to: 'forgot_passwords#confirm_password_reset'

  resources :password_resets, only: [:show, :create]
  get '/invalid_token', to: 'password_resets#invalid_token'
  

  resources :cart, only: [:index] do
    collection do
      post 'add_item_to_cart'
      get 'checkout'
      post 'remove_cart_item'
      get 'check_out_shipping'
    end
    member do
      put 'change_cart_item_quantity'
      patch 'change_cart_item_quantity'
    end
  end

  resources :orders, only: [:create] do
    collection do
      get 'result'
      get 'pay_with_credit_card'
    end
  end

  namespace :admin do
    get '/' => 'admin#index'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    get '/logout', to: 'sessions#destroy'

    resources :users
    resources :orders do
      member do
        get 'change_status'
      end
      collection do
        get 'export_orders'
      end
    end
    resources :products do
      resources :product_colors, only: [:index, :destroy] do
        collection do
          post "create_update"
        end
      end
      resources :product_sizes, only: [:index, :destroy] do
        collection do
          post "create_update"
        end
      end
      resources :product_quantities, only: [:index, :create]
      resources :product_pics do
        collection { post :sort }
      end
    end
    resources :news_tags, except: [:show]
    resources :categories
    resources :news
    resources :shipping_costs, except: [:show]
    resources :faqs, only: [:index, :edit, :update]
    resources :banners, except: [:show]
    resources :videos, except: [:show]
  end

  get "/*other" => redirect("/")
end
