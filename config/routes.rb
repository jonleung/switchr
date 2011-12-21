Switchr::Application.routes.draw do

  root :to => 'sessions#new'

  resources :dev_sessions, :only => [:new, :create, :destroy]
  get 'developer' => 'dev_sessions#new', :as => :dev_login
  get 'developer/logout' => 'dev_sessions#destroy', :as => :dev_logout
  
  resources :devs, :only => [:index, :new, :create, :show, :destroy]
  get 'developer/dashboard' => 'devs#show', :as => :dev_dashboard
  
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users, :only => [:index, :edit, :destroy]
  get 'logout' => 'sessions#destroy', :as => :logout

  resources :certs
  match 'dashboard' => 'certs#index', :as => :dashboard, :via => :get
  post 'mbed/register' => 'certs#create', :as => :mbed_reg_path
  
  resources :devices
  post 'switch' => 'devices#switch', :as => :switch
  post 'mbed' => 'devices#switch'
  get 'mbeds' => 'certs#index'
  
  #TODO, restrict resources

  
  
  #API ROUTES
  
  post 'authenticate' => 'sessions#create'
  

    
end
