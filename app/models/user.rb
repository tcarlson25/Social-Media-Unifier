class User < ApplicationRecord
  validates_presence_of :name, :uid, :provider, :token, :secret, :profile_image
  # attr_encrypted :token, key: ENV['TWITTER_USER_DEF_TOKEN']
  # attr_encrypted :secret, key: ENV['TWITTER_USER_DEF_SECRET']
  has_one :feed
  
  def self.find_or_create_from_auth_hash(auth_hash)
    user = where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create do |user|
      user.name = auth_hash.info.nickname
      user.profile_image = auth_hash.info.image
      user.token = auth_hash.credentials.token
      user.secret = auth_hash.credentials.secret
    end
    user
  end
end
