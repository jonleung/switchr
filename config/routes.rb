Switchr::Application.routes.draw do
  
=begin



=end
  
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
