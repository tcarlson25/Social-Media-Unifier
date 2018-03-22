Rails.application.routes.draw do

  root 'feeds#index'
  delete '/logout', to: 'sessions#destroy'
  
  get '/auth/:provider/callback', to: 'sessions#create'
  
  get 'settings/index'
  get 'settings/metrics'
  get 'settings/custom_friends'
  get 'settings/accounts'
  
  get 'feeds/index'
  get 'feeds/messages'
  get 'feeds/archives'
  get 'feeds/notifications'
  get 'feeds/post'
  post 'feeds/post'
  
  get 'login/index'
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
