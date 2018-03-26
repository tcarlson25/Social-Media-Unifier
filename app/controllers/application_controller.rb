class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  attr_accessor :twitter_client, :facebook_client
  
  def set_sign_in_required
    'Log in with Twitter to use this application'
  end
  
  def validate_twitter_response(t_response)
    if t_response.nil?
      'Error posting tweet'
    else
      'Successfully posted!'
    end
  end
  
  def get_tweets
    @twitter_client.home_timeline
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
  end
    
  def process_image(text, image)
    File.open(Rails.root.join('app/assets/images', image.original_filename), 'wb') do |f|
      f.write(image.read)
    end
    image_path = File.join(Rails.root, 'app', 'assets', 'images', image.original_filename)
    response = @twitter_client.update_with_media(text, File.new(image_path))
    FileUtils.rm(image_path) unless response.nil?
    validate_twitter_response(response)
  end
    
  def process_images(text, images)
    image_paths = []
    images.each do |image|
      File.open(Rails.root.join('app/assets/images', image.original_filename), 'wb') do |f|
        f.write(image.read)
      end
      image_path = File.join(Rails.root, 'app', 'assets', 'images', image.original_filename)
      image_paths << image_path
    end
    if image_paths.size() > 4
        'Do not upload more than 4 images at once'
    else
      media = image_paths.map { |filename| File.new(filename) }
      response = @twitter_client.update_with_media(text, media)
      image_paths.each { |path| FileUtils.rm(path) } unless response.nil?
      validate_twitter_response(response)
    end
  end
  
  def process_text(text)
    if text.strip.empty?
      'You cannot make an empty post'
    else
      response = @twitter_client.update(text)
      validate_twitter_response(response)
    end
  end
  
end
