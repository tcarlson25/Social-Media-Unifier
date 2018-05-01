class FeedsController < ApplicationController
  
  include FeedsHelper
  attr_accessor :twitter_client, :facebook_client, :mastodon_client, :feed, :twitter_posts, :user, :providers, :posts
  layout 'feeds', :only => :index
  layout 'generalLayout', :except => [:index]
  
  def index
    @user = current_user
    redirect_to settings_accounts_path if @user.identities.empty?
    @providers = []
    @feed = Feed.find_or_create_from_user(@user)
    @posts = Hash.new("-1")
    
    unless @user.twitter.nil?
      counter = 1
      @providers << 'Twitter'
      @twitter_client = @user.twitter_client
      @twitter_posts = get_posts('Twitter')
      
      @twitter_posts.each do |post|
        @posts['twitter_' + counter.to_s] =  post
        counter += 1
      end
    end
    
    unless @user.facebook.nil?
      @facebook_client = @user.facebook_client
    end
    
    unless @user.mastodon.nil?
      counter = 1
      @providers << 'Mastodon'
      @mastodon_client = @user.mastodon_client
      @mastodon_posts = get_posts('Mastodon')
      @mastodon_posts.each do |post|
        @posts['mastodon_' + counter.to_s] =  post
        counter += 1
      end
    end
    @posts = @posts.sort_by {|key, value| DateTime.parse(value.created_at.to_s)}
    @posts = @posts.reverse
  end
  
  def messages
    @user = current_user
    redirect_to settings_accounts_path if @user.identities.empty?
    unless @user.twitter.nil?
      @twitter_client = @user.twitter_client
    end
  end
  
  def archives
    @user = current_user
    redirect_to settings_accounts_path if @user.identities.empty?
    @posts = Hash.new("-1")
    @providers = []
    
    unless @user.twitter.nil?
      counter = 1
      @providers << 'Twitter'
      @twitter_client = @user.twitter_client
      archived_twitter_posts = @user.feed.twitter_posts
      ids = []
      archived_twitter_posts.each do |post|
        ids << post.id
        @posts['twitter_' + counter.to_s] =  post
        counter += 1
      end
      
      posts = @twitter_client.statuses(ids)
      posts.each do |post|
        archived_twitter_posts.find_by(id: post.id).update_attribute(:favorite_count, post.favorite_count)
        archived_twitter_posts.find_by(id: post.id).update_attribute(:retweet_count, post.retweet_count)
        archived_twitter_posts.find_by(id: post.id).update_attribute(:favorited, post.favorited?)
        archived_twitter_posts.find_by(id: post.id).update_attribute(:retweeted, post.retweeted?)
      end
    end
    
    unless @user.facebook.nil?
      @facebook_client = @user.facebook_client
    end
    
    unless @user.mastodon.nil?
      counter = 1
      @providers << 'Mastodon'
      @mastodon_client = @user.mastodon_client
      archived_mastodon_posts = @user.feed.mastodon_posts
      ids = []
      archived_mastodon_posts.each do |post|
        ids << post.id
        @posts['mastodon_' + counter.to_s] =  post
        counter += 1
      end
      
      posts = []
      ids.each do |id|
        posts << @mastodon_client.status(id)
      end
      
      posts.each do |post|
        archived_mastodon_posts.find_by(id: post.id).update_attribute(:favourites_count, post.favourites_count)
        archived_mastodon_posts.find_by(id: post.id).update_attribute(:reblogs_count, post.reblogs_count)
        archived_mastodon_posts.find_by(id: post.id).update_attribute(:favourited, post.favourited?)
        archived_mastodon_posts.find_by(id: post.id).update_attribute(:reblogged, post.reblogged?)
      end
    end
    
    @posts = @posts.sort_by {|key, value| DateTime.parse(value.post_made_at.to_s)}
    @posts = @posts.reverse
  end
  
  def notifications
    @user = current_user
    redirect_to settings_accounts_path if @user.identities.empty?
    if @user.twitter != nil
      @twitter_client = @user.twitter_client
    end
  end
  
  def post
    @user = current_user
    redirect_to settings_accounts_path if @user.identities.empty?
    @providers = []
    @providers << 'Twitter' unless @user.twitter.nil?
    @providers << 'Facebook' unless @user.facebook.nil?
    @providers << 'Mastodon' unless @user.mastodon.nil?
    if params[:providers]
      checked_providers = params[:providers].keys
      @twitter_client = @user.twitter_client if checked_providers.include?('Twitter')
      @facebook_client = @user.facebook_client if checked_providers.include?('Facebook')
      @mastodon_client = @user.mastodon_client if checked_providers.include?('Mastodon')
      unless params[:images].nil?
        if params[:images].size() == 1
          single = true
          responses = process_image(params[:post_content], params[:images][0])
          flash[:notify] = responses[:errors].join(',')
        else
          multi = true
          responses = process_images(params[:post_content], params[:images])
          flash[:notify] = responses[:errors].join(',')
        end
      else
        responses = process_text(params[:post_content])
        flash[:notify] = responses[:errors].join(',')
      end
    end
  end
  
end