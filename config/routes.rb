NoteApp::Application.routes.draw do
  #match 'users/sign_up' => 'registrations#new'
  #match 'users' => 'registrations#create', :via => post
  #resources :registrations
  devise_for :users, :controllers => {
                       :confirmations => "confirmations",
                       :registrations => "registrations"
                   }
  devise_scope :user do
    post 'users/set_up_details/:confirmation_token' => 'registrations#initialize_user_details'
    authenticated do
      root to: 'notes#index'
      get 'user/edit_password' => 'passwords#edit_password'
      post 'user/update_password' => 'passwords#update_password'
    end

    unauthenticated do
      root to: 'devise/sessions#new'
    end
  end

  authenticate :user do
    #notes
    get 'notes/list' => 'notes#user_note_list'
    get 'user/:id/notes/list' => 'notes#note_list_for_profile'
    delete 'note_sharings/:note_id/user/:user_id' => 'notes#destroy_shared_user'
    resources :notes

    #user_profile
    get 'user_profile/:id' => 'user_profile#show'
    get 'user_profile' => 'user_profile#index'

    #search
    get 'search/autocomplete' => 'search#search_autocomplete'
    get 'search/detailed_results/:search_string' => 'search#detailed_search_results'
  end

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
