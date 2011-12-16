Switchr::Application.routes.draw do
  root :to => 'users#new'
  
  match 'dashboard' => 'users#dashboard', :as => :dashboard, :via => :get
  get 'logout' => 'sessions#destroy', :as => 'logout'
  
  resources :users
  resources :sessions
end
