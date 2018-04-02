class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
          :trackable, :omniauthable, :omniauth_providers => [:twitter, :facebook] 
  has_one :feed
  has_many :identities
  
  def twitter
    identities.where(:provider => "twitter").first
  end
  
  def twitter_client
     @current_twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = twitter.token
      config.access_token_secret = twitter.secret
    end
  end
  
  def facebook
    identities.where(:provider => "facebook").first
  end
  
  
end
