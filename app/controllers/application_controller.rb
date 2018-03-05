class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_client, :current_user
  
  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def current_client
    @current_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = @user.encrypted_token
      config.access_token_secret = @user.encrypted_secret
    end
  end
  
end
