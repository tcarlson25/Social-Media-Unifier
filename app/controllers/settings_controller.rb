class SettingsController < ApplicationController
  
  attr_accessor :twitter_client, :user
  layout 'settings'
  
  def index
    @user = current_user
    @twitter_client = @user.twitter_client unless @user.twitter.nil?
    @facebook_client = @user.facebook_client unless @user.facebook.nil?
  end
  
  def metrics
    @user = current_user
    @twitter_client = @user.twitter_client unless @user.twitter.nil?
    @facebook_client = @user.facebook_client unless @user.facebook.nil?
    #print stuff here
    #also in haml
  end
  
  def custom_friends
    @user = current_user
    @twitter_client = @user.twitter_client unless @user.twitter.nil?
    @facebook_client = @user.facebook_client unless @user.facebook.nil?
  end
  
  def accounts
    @user = current_user
    @logged_in_identities = @user.identities
    providers = ['facebook', 'twitter', 'mastodon']
    @available_providers = []
    providers.each do |provider|
      @available_providers << provider.capitalize unless @user.logged_in_providers.include?(provider)
    end
  end
  
  def logout
    @user = current_user
    logout_provider = params[:provider]
    @user.delete_identity(logout_provider)
    redirect_to settings_accounts_path
  end
  
end
