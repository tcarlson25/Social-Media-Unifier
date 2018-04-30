module ApplicationHelper
  
  def favorite(id, provider)
    if provider.eql?('tw')
      @twitter_client.favorite(id)
      @user.twitter.update_attribute(:like_count, @user.twitter.like_count + 1)
    elsif provider.eql?('ma')
      @mastodon_client.favourite(id)
      @user.mastodon.update_attribute(:like_count, @user.mastodon.like_count + 1)
    end
  end
  
  def unfavorite(id, provider)
    if provider.eql?('tw')
      @twitter_client.unfavorite(id)
      @user.twitter.update_attribute(:like_count, @user.twitter.like_count - 1)
    elsif provider.eql?('ma')
      @mastodon_client.unfavourite(id)
      @user.mastodon.update_attribute(:like_count, @user.mastodon.like_count - 1)
    end
  end
  
  def repost(id, provider)
    if provider.eql?('tw')
      @twitter_client.retweet(id)
      @user.twitter.update_attribute(:repost_count, @user.twitter.repost_count + 1)
    elsif provider.eql?('ma')
      @mastodon_client.reblog(id)
      @user.mastodon.update_attribute(:repost_count, @user.mastodon.repost_count + 1)
    end
  end
  
  def unrepost(id, provider)
    if provider.eql?('tw')
      @twitter_client.unretweet(id)
      @user.twitter.update_attribute(:repost_count, @user.twitter.repost_count - 1)
    elsif provider.eql?('ma')
      @mastodon_client.unreblog(id)
      @user.mastodon.update_attribute(:repost_count, @user.mastodon.repost_count - 1)
    end
  end
  
  def archive_post(id, provider)
    if provider.eql?('tw')
      post_to_archive = @twitter_client.status(id, tweet_mode: "extended")
      @user.feed.twitter_posts.archive(post_to_archive)
    end
    
    if provider.eql?('ma')
      post_to_archive = @mastodon_client.status(id)
      @user.feed.mastodon_posts.archive(post_to_archive)
    end
  end
  
  def unarchive_post(id, provider)
    if provider.eql?('tw')
      post_to_unarchive = @twitter_client.status(id, tweet_mode: "extended")
      @user.feed.twitter_posts.archive(post_to_unarchive).destroy
    end
    if provider.eql?('ma')
      post_to_unarchive = @mastodon_client.status(id)
      @user.feed.mastodon_posts.archive(post_to_unarchive).destroy
    end
  end
  
  def archived?(provider, id)
    foundPost = @user.feed.twitter_posts.find_by(id: id) if provider.eql?('twitter')
    foundPost = @user.feed.mastodon_posts.find_by(id: id) if provider.eql?('mastodon')
    if foundPost.nil?
      return false
    else
      return true
    end
  end
  
  def filter_feed_search(query)
    respond_to do |format|
      format.js {render :js => 'filterFeedSearch(\'' + query.to_s + '\')'}
    end
  end
  
end
