Rails.application.routes.draw do

  root 'posts#index'
  delete '/logout', to: 'sessions#destroy'
  
  get '/auth/:provider/callback', to: 'sessions#create'
  
  get 'settings/index'
  get 'settings/metrics'
  get 'settings/custom_friends'
  get 'settings/accounts'
  
  get 'posts/messages'
  get 'posts/archives'
  get 'posts/notifications'
  
  get 'login/index'
  
  resources :posts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
