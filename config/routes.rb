Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  #as :user do
  #  get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
  #  get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  #end
  
  root to: 'feeds#index'
  
  #get '/auth/:provider/callback', to: 'sessions#create'
  
  get 'settings/index'
  get 'settings/metrics'
  get 'settings/custom_friends'
  get 'settings/accounts'
  post 'settings/logout'
  
  get 'feeds/index'
  get 'feeds/messages'
  get 'feeds/archives'
  get 'feeds/notifications'
  get 'feeds/post'
  post 'feeds/post'
  
  post 'application/req_favorite'
  post 'application/req_unfavorite'
  post 'application/req_repost'
  post 'application/req_unrepost'
  post 'application/req_archive_post'
  post 'application/req_unarchive_post'
  post 'application/req_filter_feed_search'
  
  get 'login/index'
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
