class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  attr_accessor :twitter_client, :facebook_client, :mastodon_client
  helper_method :get_tweets, :archived?
  
  def validate_responses(t_response, f_response, m_response)
    error_hash = {:errors => []}
    error_hash[:errors] << 'Could not post to Twitter.' if t_response.nil?
    error_hash[:errors] << 'Could not post to Facebook.' if f_response.nil?
    error_hash[:errors] << 'Could not post to Mastodon.' if m_response.nil?
    error_hash[:errors] << 'Posted Successfully!' if error_hash[:errors].empty?
    error_hash
  end
  
  def get_posts(provider)
    return @twitter_client.home_timeline if provider.eql?('Twitter')
    return @mastodon_client.home_timeline if provider.eql?('Mastodon')
  end
  
  def get_tweets_from_db
    # USE BELOW TO POPULATE DB if not already there
    # ----------------------------
    # tweets = @twitter_client.home_timeline
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
  end
  
  def favorite
    id = params[:id]
    provider = params[:provider]
    @user = current_user
    if provider.eql?('tw')
      @twitter_client = @user.twitter_client
      @twitter_client.favorite(id)
      @user.twitter.update_attribute(:like_count, @user.twitter.like_count + 1)
    elsif provider.eql?('ma')
      @mastodon_client = @user.mastodon_client
      @mastodon_client.favourite(id)
      @user.mastodon.update_attribute(:like_count, @user.mastodon.like_count + 1)
    end
  end
  
  def unfavorite
    id = params[:id]
    provider = params[:provider]
    @user = current_user
    if provider.eql?('tw')
      @twitter_client = @user.twitter_client
      @twitter_client.unfavorite(id)
      @user.twitter.update_attribute(:like_count, @user.twitter.like_count - 1)
    elsif provider.eql?('ma')
      @mastodon_client = @user.mastodon_client
      @mastodon_client.unfavourite(id)
      @user.mastodon.update_attribute(:like_count, @user.mastodon.like_count - 1)
    end
  end
  
  def repost
    id = params[:id]
    provider = params[:provider]
    @user = current_user
    if provider.eql?('tw')
      @twitter_client = @user.twitter_client
      @twitter_client.retweet(id)
      @user.twitter.update_attribute(:repost_count, @user.twitter.repost_count + 1)
    elsif provider.eql?('ma')
      @mastodon_client = @user.mastodon_client
      @mastodon_client.reblog(id)
      @user.mastodon.update_attribute(:repost_count, @user.mastodon.repost_count + 1)
    end
  end
  
  def unrepost
    id = params[:id]
    provider = params[:provider]
    @user = current_user
    if provider.eql?('tw')
      @twitter_client = @user.twitter_client
      @twitter_client.unretweet(id)
      @user.twitter.update_attribute(:repost_count, @user.twitter.repost_count - 1)
    elsif provider.eql?('ma')
      @mastodon_client = @user.mastodon_client
      @mastodon_client.unreblog(id)
      @user.mastodon.update_attribute(:repost_count, @user.mastodon.repost_count - 1)
    end
  end
  
  def archive_post
    #puts "inside Test"
    id = params[:id]
    provider = params[:provider]
    @user = current_user
    if provider.eql?('tw')
      post_to_archive = @user.twitter_client.status(id)
      #puts post_to_archive.to_json
      @user.feed.twitter_posts.archive(post_to_archive)
    end
    
    if provider.eql?('ma')
      post_to_archive = @user.mastodon_client.status(id)
      @user.feed.mastodon_posts.archive(post_to_archive)
    end
    #redirect_to root_path
  end
  
  def unarchive_post
    id = params[:id]
    provider = params[:provider]
    @user = current_user
    if provider.eql?('tw')
      post_to_unarchive = @user.twitter_client.status(id)
      archived_post = @user.feed.twitter_posts.archive(post_to_unarchive)
      archived_post.destroy
    end
    if provider.eql?('ma')
      post_to_unarchive = @user.mastodon_client.status(id)
      archived_post = @user.feed.mastodon_posts.archive(post_to_unarchive)
      archived_post.destroy
    end
  end
  
  def archived?(provider, id)
    @user = current_user
    foundPost = @user.feed.twitter_posts.find_by(id: id) if provider.eql?('twitter')
    foundPost = @user.feed.mastodon_posts.find_by(id: id) if provider.eql?('mastodon')
    if foundPost.nil?
      return false
    else
      return true
    end
    
  end
  
  def filter_feed_search
    query = params[:text_content]
    respond_to do |format|
      format.js {render :js => 'filterFeedSearch(\'' + query.to_s + '\')'}
    end
  end
  
  def process_image(text, image)
    File.open(Rails.root.join('app/assets/images', image.original_filename), 'wb') do |f|
      f.write(image.read)
    end
    image_path = File.join(Rails.root, 'app', 'assets', 'images', image.original_filename)
    @twitter_client.nil? ? (twitter_response = '') : (twitter_response = @twitter_client.update_with_media(text, File.new(image_path)).to_s)
    @facebook_client.nil? ? (facebook_response = '') : (facebook_response = @facebook_client.put_picture(image_path, {:caption => text}).to_s)
    mastodon_response = ''
    unless @mastodon_client.nil?
      img_id = @mastodon_client.upload_media(File.new(image_path)).id
      mastodon_response = @mastodon_client.create_status(text, nil, [img_id]).to_s
    end
    FileUtils.rm(image_path)
    error_hash = validate_responses(twitter_response, facebook_response, mastodon_response)
    update_image_postcount(twitter_response, facebook_response, mastodon_response, 1)
    update_postcount(twitter_response, facebook_response, mastodon_response)
    error_hash
  end
    
  def process_images(text, images)
    error_hash = {:errors => []}
    image_paths = []
    images.each do |image|
      image_path = Rails.root.join('app/assets/images', image.original_filename)
      File.open(image_path, 'wb') do |f|
        f.write(image.read)
      end
      image_paths << image_path
    end
    if image_paths.size() > 4
        error_hash[:errors] << 'Do not upload more than 4 images at once'
    else
      media = image_paths.map { |filename| File.new(filename) }
      @twitter_client.nil? ? (twitter_response = '') : (twitter_response = @twitter_client.update_with_media(text, media).to_s)
      facebook_response = ''
      unless @facebook_client.nil? 
        images_hash = {}
        image_ids = []
        image_paths.each do |path|
          fb_photo = @facebook_client.put_picture(path.to_s, {:published => false})
          image_ids << fb_photo['id']
        end
        image_ids.each_with_index{|id, index| images_hash["attached_media[#{index}]"] = "{media_fbid: #{id}}"}
        facebook_response = @facebook_client.put_connections('me', 'feed', images_hash.merge({:message => text})).to_s
      end
      mastodon_response = ''
      unless @mastodon_client.nil? 
        image_ids = []
        image_paths.each do |path|
          ma_photo = @mastodon_client.upload_media(File.new(path))
          image_ids << ma_photo.id
        end
        mastodon_response = @mastodon_client.create_status(text, nil, image_ids).to_s
      end
      error_hash = validate_responses(twitter_response, facebook_response, mastodon_response)
      update_image_postcount(twitter_response, facebook_response, mastodon_response, image_paths.size())
      update_postcount(twitter_response, facebook_response, mastodon_response)
    end
    image_paths.each { |path| FileUtils.rm(path) }
    error_hash
  end
  
  def process_text(text)
    error_hash = {:errors => []}
    if text.strip.empty?
      error_hash[:errors] << 'You cannot make an empty post'
    else
      @twitter_client.nil? ? (twitter_response = '') : (twitter_response = @twitter_client.update(text).to_s)
      @facebook_client.nil? ? (facebook_response = '') : (facebook_response = @facebook_client.put_wall_post(text).to_s)
      @mastodon_client.nil? ? (mastodon_response = '') : (mastodon_response = @mastodon_client.create_status(text).to_s)
      error_hash = validate_responses(twitter_response, facebook_response, mastodon_response)
      update_postcount(twitter_response, facebook_response, mastodon_response)
    end
    error_hash
  end
  
  def update_postcount(t_response, f_response, m_response)
    unless t_response.nil? || t_response.empty?
      @user.twitter.update_attribute(:post_count, @user.twitter.post_count + 1)
    end
      
    unless f_response.nil? || f_response.empty?
      @user.facebook.update_attribute(:post_count, @user.facebook.post_count + 1)
    end
    
    unless m_response.nil? || m_response.empty?
      @user.mastodon.update_attribute(:post_count, @user.mastodon.post_count + 1)
    end
  end
  
  def update_image_postcount(t_response, f_response, m_response, num_images)
    unless t_response.nil? || t_response.empty?
      @user.twitter.update_attribute(:image_post_count, @user.twitter.image_post_count + num_images)
    end
    
    unless f_response.nil? || f_response.empty?
      @user.facebook.update_attribute(:image_post_count, @user.facebook.image_post_count + num_images)
    end
    
    unless m_response.nil? || m_response.empty?
      @user.mastodon.update_attribute(:image_post_count, @user.mastodon.image_post_count + num_images)
    end
  end
  
end
