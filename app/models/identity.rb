class Identity < ApplicationRecord
  belongs_to :user
  
  def self.find_from_auth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |identity|
          identity.provider = auth.provider
          identity.uid = auth.uid
          identity.name = auth.info.nickname
          identity.email = auth.info.email
          identity.token = auth.credentials.token
          identity.secret = auth.credentials.secret
      end
  end
end
