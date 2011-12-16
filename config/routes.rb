Switchr::Application.routes.draw do
  root :to => 'users#new'
  
  match 'dashboard' => 'users#dashboard', :as => :dashboard, :via => :get
  
  resources :users
  resources :sessions
end
