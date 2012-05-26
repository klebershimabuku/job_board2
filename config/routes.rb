JobBoard2::Application.routes.draw do
  root to: "static_pages#home"

  devise_for :users, :path_prefix => 'd', :controllers => { :registrations => "registrations" }, :path_names => { 
                                            :sign_up => "register", 
                                            :sign_in => "login", 
                                            :sign_out => "logout" 
                                          }
  resources :users
  resources :posts do
    collection do
      get :successful_submitted, as: 'successful_submitted'
    end
  end

  match '/seja-bem-vindo', :to => 'users#welcome', :as => 'user_registration_successfull'
  match "/ajuda", to: "static_pages#help"
  match "/sobre", to: "static_pages#about"
  match "/contato", to: "static_pages#contact"
end
