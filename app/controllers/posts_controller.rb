class PostsController < ApplicationController
  def index
    @user = current_user
    if @user == nil
      helpers.set_sign_in_required
      redirect_to login_index_path
    else
      @client = current_client
      #get_tweets
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
  
  #def get_tweets
  #  @tweets = @client.home_timeline
  #  @tweets.each do |tweet|
  #    puts 'Tweet Created at: ' + tweet.created_at.to_s
  #    puts 'Tweet Content: ' + tweet.full_text.to_s
  #    puts 'Retweet Count: ' + tweet.retweet_count.to_s
  #    puts 'Favorite Count: ' + tweet.favorite_count.to_s
  #  end
  #end
  
end
