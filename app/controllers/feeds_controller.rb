class FeedsController < ApplicationController
  
  def set_client(client)
    @client = client
  end
  
  def index
    @user = current_user
    #if !@user.twitter_client.nil?
    @client = @user.twitter_client
    @feed = Feed.find_or_create_from_user(@user)
    @twitter_posts = get_tweets
    #end
  end
  
  def messages
    @user = current_user
    #@client = current_client
  end
  
  def archives
    @user = current_user
    #@client = current_client
  end
  
  def notifications
    @user = current_user
    #@client = current_client
  end
  
  def post
    #@user = current_user
    #if @user == nil
    #  helpers.set_sign_in_required
    #  redirect_to login_index_path
    #else
    #  @client = current_client
    #  @providers = ['Twitter', 'Facebook']
    #  if params[:providers]
    #    checked_providers = params[:providers].keys
    #    if(checked_providers.include?('Twitter'))
    #      response = post_tweet(params[:post_content])
    #      flash[:notice] = "Successfully posted!" unless response.nil?()
    #    end
    #  end
    #end
  end
  
  def get_tweets_with_api
    @tweets = @client.home_timeline
    return @tweets
  end
  
  def get_tweets
    ## USE BELOW TO POPULATE DB if not already there
    # ----------------------------
    tweets = @client.home_timeline
     tweets.each do |tweet|
       @feed.twitter_posts.create(
         id: tweet.id,
         user: tweet.user.name,
         content: tweet.full_text,
         imgurl: tweet.user.profile_image_url,
         favorite_count: tweet.favorite_count,
         retweet_count: tweet.retweet_count,
         post_made_at: tweet.created_at
       )
     end
    # ----------------------------
    tweets = @feed.twitter_posts
    return tweets
  end
  
  def post_tweet(status)
    @client.update(status)
  end 
  
end
