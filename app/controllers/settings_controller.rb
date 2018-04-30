class SettingsController < ApplicationController
  
  attr_accessor :twitter_client, :facebook_client, :mastodon_client, :user, :twitter_metrics, :facebook_metrics, :mastodon_metrics
  layout 'settings'
  require 'json'
  
  def index
    @user = current_user
    redirect_to settings_accounts_path if @user.identities.empty?
  end
  
  def metrics
    @user = current_user
    redirect_to settings_accounts_path if @user.identities.empty?
    
    @twitter_metrics = Hash.new("-1")
    @facebook_metrics = Hash.new("-1")
    @mastodon_metrics = Hash.new("-1")
    
    unless @user.twitter.nil?
      @twitter_metrics['post_count'] = @user.twitter.post_count
      @twitter_metrics['img_post_count'] = @user.twitter.image_post_count
      @twitter_metrics['like_count'] = @user.twitter.like_count
      @twitter_metrics['repost_count'] = @user.twitter.repost_count
      @twitter_metrics['archive_count'] = @user.feed.twitter_posts.size
    end
    
    unless @user.facebook.nil?
      @facebook_metrics['post_count'] = @user.facebook.post_count
      @facebook_metrics['img_post_count'] = @user.facebook.image_post_count
      @facebook_metrics['like_count'] = @user.facebook.like_count
      @facebook_metrics['repost_count'] = @user.facebook.repost_count
      # facebook does not have feed capability yet due to facebook privacy
      @facebook_metrics['archive_count'] = 0
    end
    
    unless @user.mastodon.nil?
      @mastodon_metrics['post_count'] = @user.mastodon.post_count
      @mastodon_metrics['img_post_count'] = @user.mastodon.image_post_count
      @mastodon_metrics['like_count'] = @user.mastodon.like_count
      @mastodon_metrics['repost_count'] = @user.mastodon.repost_count
      @mastodon_metrics['archive_count'] = @user.feed.mastodon_posts.size
    end
  end
  
  def custom_friends
    @user = current_user
    redirect_to settings_accounts_path if @user.identities.empty?
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
