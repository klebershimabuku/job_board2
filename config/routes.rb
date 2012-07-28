JobBoard2::Application.routes.draw do
  ActiveAdmin.routes(self)

  root to: "static_pages#home"
  
  devise_for :users, :path_prefix => 'd', :controllers => { :registrations => "registrations" }, :path_names => { 
                                            :sign_up => "register", 
                                            :sign_in => "login", 
                                            :sign_out => "logout" 
                                          }
  resources :users do 
    resources :contact_infos
  end
  
  resources :posts do
    collection do
      get :successful_submitted, as: 'successful_submitted'
    end
    member do 
      get :suspend_alert, as: 'suspend_alert'
      get :suspend, as: 'suspend'
    end
  end
  get 'posts/tags/:tags' => 'posts#tags', as: 'tags_filter_post'

  resources :companies, path: 'empresas' do
    collection do
      get :prefectures, to: 'companies#prefectures', path: 'provincias'
      get '/provincias/:name', to: 'companies#list', as: 'list'
    end
  end

  get '/agencias-hello-work', to: 'agencies#index', as: 'hello_work_agencies'
  get '/agencias-hello-work/:prefecture_name', to: 'agencies#list', as: 'hello_work_list_agencies'

  namespace :empresas do 
    match ':name', to: 'companies#show', as: 'provincia'
  end

  match '/seja-bem-vindo', :to => 'users#welcome', :as => 'user_registration_successfull'
  match "/ajuda", to: "static_pages#help"
  match "/sobre", to: "static_pages#about"
  match "/contato", to: "static_pages#contact"
end
