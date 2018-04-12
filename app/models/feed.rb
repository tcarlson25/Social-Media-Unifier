class Feed < ApplicationRecord
    validates_presence_of :user_id
    has_many :twitter_posts
    has_many :mastodon_posts
    belongs_to :user
    
    def self.find_or_create_from_user(user)
        where(user_id: user.id).first_or_create do |feed|
            #feed.username = user.name
            feed.user_id = user.id
        end
    end
    
end
