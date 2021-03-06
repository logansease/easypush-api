SampleApp::Application.routes.draw do  
 
  
  resources :sessions, :only => [:new, :create, :destroy] do 
    collection do
      post :fb_signin
    end
  end
  
  resources :users do
    member do
      post :fb_unlink
      get :following, :followers       #makes users/1/following and following_user_path
    end
    collection do
      post :send_password_recovery
      get :password_recovery
      get :activate
      get :send_activation
      post :create_fb
      get :new_fb
    end
  end

  resources :apps do
    collection do
      get :show_level
      get :show_users
    end
  end
  resources :push_notifications, :only => [:index]  do
    collection do
      get :create_message
      post :send_message
    end
  end
  resources :microposts, :only => [:create, :destroy] 
  resources :relationships, :only => [:create, :destroy]
  resources :fb_connections, :only => [:create, :destroy]
  resources :promo_codes do
    collection do
      get :redeem
    end
  end

  #subscriptions
  resources :subscriptions do
    collection do
      get :manage
    end
  end
  resources :plans

  root :to => "pages#home" 
  match '/signup', :to => 'users#new'
  match '/get_started', :to => 'pages#doc'
  match '/about', :to => 'pages#about'   
  match '/help', :to => 'pages#help'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/contact', :to => 'pages#contact'

  match '/api/save_score', :to => 'api#save_score'
  match '/api/get_scores', :to => 'api#get_scores'
  match '/api/save_user', :to => 'api#save_user'
  match '/api/register_push', :to => 'api#register_push'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
