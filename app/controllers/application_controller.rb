class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  include ApplicationHelper
  
  def req_favorite
    @user = current_user
    @twitter_client = @user.twitter_client unless @user.twitter.nil?
    @mastodon_client = @user.mastodon_client unless @user.mastodon.nil?
    favorite(params[:id], params[:provider])
    head :ok
  end
  
  def req_unfavorite
    @user = current_user
    @twitter_client = @user.twitter_client unless @user.twitter.nil?
    @mastodon_client = @user.mastodon_client unless @user.mastodon.nil?
    unfavorite(params[:id], params[:provider])
    head :ok
  end
  
  def req_repost
    @user = current_user
    @twitter_client = @user.twitter_client unless @user.twitter.nil?
    @mastodon_client = @user.mastodon_client unless @user.mastodon.nil?
    repost(params[:id], params[:provider])
    head :ok
  end
  
  def req_unrepost
    @user = current_user
    @twitter_client = @user.twitter_client unless @user.twitter.nil?
    @mastodon_client = @user.mastodon_client unless @user.mastodon.nil?
    unrepost(params[:id], params[:provider])
    head :ok
  end
  
  def req_archive_post
    @user = current_user
    @twitter_client = @user.twitter_client unless @user.twitter.nil?
    @mastodon_client = @user.mastodon_client unless @user.mastodon.nil?
    archive_post(params[:id], params[:provider])
    head :ok
  end
  
  def req_unarchive_post
    @user = current_user
    @twitter_client = @user.twitter_client unless @user.twitter.nil?
    @mastodon_client = @user.mastodon_client unless @user.mastodon.nil?
    unarchive_post(params[:id], params[:provider])
    head :ok
  end
  
  def req_filter_feed_search
    filter_feed_search(params[:text_content])
  end
  
end
