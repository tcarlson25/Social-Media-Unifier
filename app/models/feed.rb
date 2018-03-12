class Feed < ApplicationRecord
    has_many :twitter_posts
    belongs_to :user
    
    scope :find_by_user, lambda { |username| where(:user => username)}
    
    def self.find_or_create_from_user(user)
        feed = where(username: user.name).first_or_create do |feed|
            feed.username = user.name
            feed.user_id = user.id
        end
        feed
    end
    
end
