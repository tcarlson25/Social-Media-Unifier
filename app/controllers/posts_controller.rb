class PostsController < ApplicationController
  def index
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
      # comment out get_tweets if using too much of API
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
    tweets = @client.home_timeline
    tweets.each do |tweet|
      # Post.create( provider: ':twitter',
      #               content: tweet.text,
      #               created_at: tweet.created_at,
      #               retweet_count: tweet.retweet_count,
      #               favorite_count: tweet.favorite_count
      #               )
                    #what attributes does post have?
    end
    return tweets
  end
  
end
