class FeedsController < ApplicationController
  def index
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
      @feed = @user.feed
      @twitter_posts = get_tweets
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
  
  def get_tweets
    ## USE BELOW TO POPULATE DB if not already there
    # ----------------------------
    # tweets = @client.home_timeline
    # tweets.each do |tweet|
    #   @feed.twitter_posts.create(
    #     id: tweet.id,
    #     feed_id: @feed.id,
    #     user: tweet.user.name,
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
  
end
