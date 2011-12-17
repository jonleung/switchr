Switchr::Application.routes.draw do

  resources :dev_sessions, :only => [:new, :create, :destroy]
  get 'developer' => 'dev_sessions#new', :as => :dev_login
  get 'developer/logout' => 'dev_sessions#destroy', :as => :dev_logout
  
  resources :devs, :only => [:index, :new, :create, :show, :destroy]
  get 'developer/dashboard' => 'devs#show', :as => :dev_dashboard
  
 



  root :to => 'users#new'
  
  match 'dashboard' => 'certs#index', :as => :dashboard, :via => :get
  get 'logout' => 'sessions#destroy', :as => :logout
  post 'switch' => 'devices#switch', :as => :switch
  
  #TODO, restrict resources
  resources :users
  resources :sessions
  resources :devices
  resources :certs

    
end
