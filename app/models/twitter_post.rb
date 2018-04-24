class TwitterPost < ApplicationRecord
    belongs_to :feed
    
    def self.archive(post)
       where(id: post.id).first_or_create do |tw_post|
          tw_post.id = post.id
          tw_post.name = post.user.name
          tw_post.username = post.user.screen_name
          tw_post.content = post.full_text
          tw_post.profile_img = post.user.profile_image_url
        #   tw_post.imgurls = put media attachments here
          tw_post.favorite_count = post.favorite_count
          tw_post.retweet_count = post.retweet_count
          tw_post.post_made_at = post.created_at
          tw_post.favorited = post.favorited?
          tw_post.retweeted = post.retweeted?
       end
    end
end
