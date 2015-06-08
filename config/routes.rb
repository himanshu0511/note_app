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
