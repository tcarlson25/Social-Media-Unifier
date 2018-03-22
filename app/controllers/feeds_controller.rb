class FeedsController < ApplicationController
  
  attr_accessor :client, :feed, :twitter_posts, :user, :providers
  
  def index
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
      @feed = @user.feed
      @twitter_posts = get_tweets_from_db
    end
  end
  
  def messages
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
        @client = current_client
    end  
  end
  
  def archives
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
        @client = current_client
    end  
  end
  
  def notifications
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
        @client = current_client
    end
  end
  
  def post
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
      @providers = ['Twitter', 'Facebook']
      if params[:providers]
        checked_providers = params[:providers].keys
        if checked_providers.include?('Twitter')
          unless params[:images].nil?
            if params[:images].size() == 1
              image = params[:images][0]
              helpers.process_image(image)
            else
              images = params[:images]
              helpers.process_images(images)
            end
          else
            text = params[:post_content]
            helpers.process_text(text)
          end
        end
        
        if checked_providers.include?('Facebook')
          
        end
      end
    end
  end
  
  def get_tweets
    @tweets = @client.home_timeline
    return @tweets
  end
  
  def get_tweets_from_db
    # USE BELOW TO POPULATE DB if not already there
    # ----------------------------
    # tweets = @client.home_timeline
    # tweets.each do |tweet|
    #   @feed.twitter_posts.create(
    #     id: tweet.id,
    #     name: tweet.user.name,
    #     user_name: tweet.user.screen_name,
    #     content: tweet.full_text,
    #     imgurl: tweet.user.profile_image_url,
    #     favorite_count: tweet.favorite_count,
    #     retweet_count: tweet.retweet_count,
    #     post_made_at: tweet.created_at
    #   )
    # end
    # ----------------------------
    tweets = @feed.twitter_posts
    return tweets
  end
  
  # def post_tweet(status)
  #   @client.update(status)
  # end 
  
  # def post_image(text, image_path)
  #   @client.update_with_media(text, File.new(image_path))
  # end
  
  # def post_images(text, media)
  #   @client.update_with_media(text, media)
  # end
  
end
