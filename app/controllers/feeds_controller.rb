class FeedsController < ApplicationController
  
  attr_accessor :twitter_client, :facebook_client, :mastodon_client, :feed, :twitter_posts, :user, :providers, :posts
  layout 'feeds'
  
  def index
    @user = current_user
    @feed = Feed.find_or_create_from_user(@user)
    @posts = Hash.new("-1")
    
    unless @user.twitter.nil?
      counter = 1
      @twitter_client = @user.twitter_client
      @twitter_posts_db = get_tweets_from_db
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
      @mastodon_client = @user.mastodon_client
      @mastodon_posts = get_posts('Mastodon')
      @mastodon_posts.each do |post|
        @posts['mastodon_' + counter.to_s] =  post
        counter += 1
      end
    end
    @posts = @posts.sort_by {|key, value| DateTime.parse(value.created_at.to_s)}.to_h
  end
  
  def messages
    @user = current_user
    if @user.twitter != nil
      @twitter_client = @user.twitter_client
    end
  end
  
  def archives
    @user = current_user
    if @user.twitter != nil
      @twitter_client = @user.twitter_client
    end
  end
  
  def notifications
    @user = current_user
    if @user.twitter != nil
      @twitter_client = @user.twitter_client
    end
  end
  
  
  def post
    @user = current_user
    @providers = []
    @providers << 'Twitter' unless @user.twitter.nil?
    @providers << 'Facebook' unless @user.facebook.nil?
    @providers << 'Mastodon' unless @user.mastodon.nil?
    if params[:providers]
      checked_providers = params[:providers].keys
      @twitter_client = @user.twitter_client if @providers.include?('Twitter')
      @facebook_client = @user.facebook_client if @providers.include?('Facebook')
      @mastodon_client = @user.mastodon_client if @providers.include?('Mastodon')
      single = false
      multi = false
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
      if single == true
        #user identity image count += 1
        # @user.twitter.posts += 1
      end
      if multi == true
        #user identity image count += params.size
      end
      #user identity post count =+ 1
    end
  end
  
  
end