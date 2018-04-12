class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
          :trackable, :omniauthable, :omniauth_providers => [:twitter, :facebook, :mastodon, :google_oauth2] 
  has_one :feed
  has_many :identities
  
  attr_accessor :current_twitter_client, :current_facebook_client, :current_mastodon_client
  
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
        user = User.create(
            name: data['name'],
            email: data['email']
        )
    end
    user
end
  
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
  
  def facebook_client 
    @current_facebook_client = Koala::Facebook::API.new(facebook.token)
  end
  
  def mastodon
    identities.where(:provider => 'mastodon').first
  end
  
  def mastodon_client
    @current_mastodon_client = Mastodon::REST::Client.new(base_url: 'https://mastodon.social', bearer_token: mastodon.token)
  end
  
  def logged_in_providers()
    self.identities.pluck(:provider)
  end
  
  def delete_identity(logout_provider)
    self.identities.where(:provider => logout_provider).destroy_all
  end

end
