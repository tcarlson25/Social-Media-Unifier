class SettingsController < ApplicationController
  
  attr_accessor :twitter_client, :user
  
  def index
     @user = current_user
     @twitter_client = @user.twitter_client
  end
  
  def metrics
    @user = current_user
    @twitter_client = @user.twitter_client
  end
  
  def custom_friends
    @user = current_user
    @twitter_client = @user.twitter_client
  end
  
  def accounts
    @user = current_user
    @twitter_client = @user.twitter_client
  end
  
end
