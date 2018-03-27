class FeedsController < ApplicationController
  
  attr_accessor :twitter_client, :feed, :twitter_posts, :user, :providers
  
  
  def index
    @user = current_user
    @feed = Feed.find_or_create_from_user(@user)
    if @user.twitter != nil
      @twitter_client = @user.twitter_client
      @twitter_posts_db = get_tweets_from_db
      @twitter_posts = get_tweets
    end
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
    # @client = current_client
    @providers = ['Twitter', 'Facebook']
    if params[:providers]
      checked_providers = params[:providers].keys
      if checked_providers.include?('Twitter')
        @twitter_client = @user.twitter_client
        unless params[:images].nil?
          if params[:images].size() == 1
            response = process_image(params[:post_content], params[:images][0])
            flash[:notice] = response
          else
            response = process_images(params[:post_content], params[:images])
            flash[:notice] = response
          end
        else
          response = process_text(params[:post_content])
          flash[:notice] = response
        end
      end
        
      if checked_providers.include?('Facebook')
          
      end
    end
  end
  
end
