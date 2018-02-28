Rails.application.routes.draw do

  root 'login#index'
  delete '/logout', to: 'sessions#destroy'
  
  get '/auth/:provider/callback', to: 'sessions#create'
  
  get 'settings/index'
  get 'settings/metrics'
  get 'settings/custom_friends'
  get 'settings/accounts'
  
  get 'login/index'
  
  resources :posts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
